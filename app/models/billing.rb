class Billing < ApplicationRecord
	FEATURED_PRICES = {
		'FeaturedBuilding' => 49
	}.freeze

	TYPE_TOOLS = {
		'FeaturedBuilding' => 'Manager'
	}.freeze
	
	belongs_to :billable, polymorphic: true
	belongs_to :user

	attr_accessor :description, :strp_customer_id
	validates_presence_of :email

	after_save :set_end_date, unless: :payment_failed?

	default_scope { order(created_at: :desc) }

	scope :for_type, -> (type) { where(billable_type: type ).includes(:billable)}

	def payment_failed?
		status == 'Failed'
	end

	def payment_detail?
		billing_card_id && brand && last4
	end

	def price
		FEATURED_PRICES[billable_type]
	end

	def save_and_make_payment!
		if valid?
      begin
      	billing_service 			= BillingService.new(user, payment_token)
      	customer_id 					= billing_service.get_customer_id
      	card 									= billing_service.create_source(customer_id)
      	self.billing_card_id 	= card.id
      	self.brand						= card.brand
      	self.last4            = card.last4
        if self.save
        	billing_service.create_charge!(billing: self, customer_id: customer_id)
        end
      rescue Stripe::CardError => e
        errors.add :credit_card, e.message
        false
      end
    else
    	errors.add(:base, 'Email can not be blank.')  if email.blank?
    end
	end

	def self.create_billing user:, card:, customer_id:, billable:
    billing = Billing.new({ email:           user.email,
                            amount:          billable.charging_amount,
                            billable_id: 		 billable.id,
                            billable_type:   billable.class.name,
                            user_id:         user.id,
                            renew_date:      Time.zone.now,
                            billing_card_id: card.id,
                            brand:           card.brand
                          })
    
    unless billing.save_and_charge_existing_card!(user: user, customer_id: customer_id, card_id: card.id)
      billing.status = 'Failed'
      billing.save
    end
	end

	def save_and_charge_existing_card! options={}
		if valid?
			begin
				billing_service = BillingService.new(options[:user], nil)
				if save
					options.merge!(billing: self)
					billing_service.create_charge!(options)
				end
			rescue Stripe::CardError => e
	      errors.add :credit_card, e.message
	      false
	    end
	  else
	  	errors.add(:base, 'Email can not be blank.')  if email.blank?
	  end
	end
	
	def billing_description
		unless renew_date
			"ID #{billable_id} #{inv_description} #{billing_start_date(self.billable&.start_date)}"
		else
			"ID #{billable_id} Renewed #{inv_description} #{billing_start_date(renew_date + 2.day)}"
		end
	end

	def card current_user, stripe_customer_id
		billing_service = BillingService.new(current_user)
		charge_obj = billing_service.get_charge(stripe_charge_id)
		billing_service.get_card(stripe_customer_id, charge_obj.payment_method) if charge_obj.present?
	end

	def update_status status
    update_column(:status, status)
  end

  def send_receipt_in_email email, view_param, card
		BillingMailer.send_payment_receipt(billing: 	self,
                                       to_email: 	email,
                                       view: 			view_param,
                                       card: 			card).deliver
	end

	
	private
	
	def set_end_date
		klass = self.billable_type.constantize
		klass.find(billable_id).set_expiry_date(self.renew_date)
	end

	def inv_description
		"Featured #{tool_type} For #{billable_type.constantize::FEATURING_WEEKS} Weeks Starting on"
	end

	def tool_type
		billable_type&.split(/(?=[A-Z])/)[1] # camelcase split
	end

	def billing_start_date date
		date&.strftime('%b %-d, %Y')
	end
	
end
