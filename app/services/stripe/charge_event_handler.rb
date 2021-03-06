module Stripe
	class ChargeEventHandler
    def call(event)
      begin
        method = "handle_" + event.type.tr('.', '_')
        self.send method, event
      rescue JSON::ParserError => e
        # handle the json parsing error here
        raise # re-raise the exception to return a 500 error to stripe
      rescue NoMethodError => e
        #code to run when handling an unknown event
      end
    end

    def billing_user customer
      User.find_by(stripe_customer_id: customer)
    end

    def billing charge
      Billing.find_by(stripe_charge_id: charge)
    end

    def handle_charge_expired(event)
      puts 'handle_charge_expired'
    end

    def handle_charge_failed(event)
      puts 'handle_charge_failed'
    end

    def handle_charge_succeeded(event)
      billing = billing(event.data.object.id)
      billing.update_status('Successful') if billing.present?
      billing.update_column(:receipt_number, event.data.object.receipt_number)
    end

  end
end