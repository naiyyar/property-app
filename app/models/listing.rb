class Listing < ApplicationRecord
  include PgSearch::Model
  include Listable
  
  # associations
  belongs_to :building, touch: true
  counter_cache_with_conditions :building, :listings_count, active: true
  
  # constants
  BEDROOMS = [#['-1', 'Room'], 
              ['0', 'Studio'],
              ['1','1 Bed'],
              ['2', '2 Bed'],
              ['3', '3 Bed'],
              ['4', '4+ Bed']
            ].freeze

  AMENITIES = {
    months_free: 'Months Free Rent',
    owner_paid: 'Owner Paid',
    rent_stabilize: 'Rent Stabilized'
  }.freeze

  EXPORT_FORMATS = %w(xlsx csv)

  # When max_price > 15500 then using MAX_RENT
  # Assuming Listing rent can not be more than 10_00_000
  MAX_RENT = 10_00_000

  # validations
  validates_presence_of :building_address, :unit, :date_active
  validates :rent, :numericality => true, :allow_nil => true
  validates :bed, :numericality => true, :allow_nil => true
  validates :bath, :numericality => true, :allow_nil => true
  validates :free_months, :numericality => true, :allow_nil => true
  validates_date :date_active, :on => :create, :message => 'Formatting is off, must be yyyy/mm/dd'
  validates_date :date_available, :on => :create, allow_nil: true, allow_blank: true, :message => 'Formatting is off, must be yyyy/mm/dd'
  

  # scopes
  scope :active,         -> { where(active: true) }
  scope :inactive,       -> { where(active: false) }
  scope :between,        -> (from, to) { where('date_active >= ? AND date_active <= ?', from, to) }
  scope :months_free,    -> { where('free_months > ?', 0) }
  scope :owner_paid,     -> { where.not(owner_paid: nil) }
  scope :rent_stabilize, -> { where(rent_stabilize: ['true', 't']) }
  scope :between_prices, -> (min, max) { where('rent >= ? AND rent <= ?', min.to_i, max.to_i) }
  scope :with_beds,      -> (beds) { where(bed: beds) }

  pg_search_scope :search_query, 
                  against: [:building_address, :management_company],
                  :using => {  :tsearch => { prefix: true }, 
                               :trigram=> { :threshold => 0.2 } 
                            },
                  associated_against: { building: [:building_name] }

  scope :default_listing_order, -> { reorder(date_active: :desc, 
                                             management_company: :asc, 
                                             building_address: :asc,
                                             rent: :asc,
                                             unit: :asc) 
                                        }
  scope :order_by_date_active_desc, -> { reorder(date_active: :desc, rent: :asc) }
  scope :order_by_rent_asc,         -> { reorder(rent: :asc, unit: :asc) }
  scope :with_rent,                 -> { where.not(rent: nil) }

  filterrific(
    default_filter_params: { },
    available_filters: [:search_query]
  )

  # callbacks
  after_save   :create_unit,  unless: :unit_exist?
  after_update :create_unit,  unless: :unit_exist?

  # delegates
  delegate :management_company, to: :building

  def self.header_style style
    EXPORT_SHEET_HEADER_ROW.map{|item| style}
  end

  def self.listings_count buildings, filter_params={}
    @filter_params = filter_params
    @buildings = buildings.select{|b| b.kind_of?(Building)}
    return @buildings.pluck(:listings_count).reduce(:+) unless listing_or_building_filter?
    filtered_listings_count
  end

  def self.transfer_to_past_listings_table listings
    self.delete_current_listings(listings, 'transfer')
  end

  def self.delete_current_listings listings, type = 'delete'
    active_listings = Listing.active.where.not(id: listings.pluck(:id))
    listings.includes(:building).each do |listing|
      building = listing.building
      PastListing.create(listing.attributes.except('id')) if type == 'transfer'
      listing.destroy
      building.update_rent(active_listings.where(building_id: building.id))
    end
  end
  
  private

  def self.listing_or_building_filter?
    @filter_params.present? || (@filter_params.present? && @filter_params[:listings].present?)
  end
  
  def create_unit
    Unit.create({ name:                 unit,
                  building_id:          building_id,
                  number_of_bedrooms:   bed,
                  number_of_bathrooms:  bath,
                  monthly_rent:         rent
                })
  end

  def self.filtered_listings_count
    listings_count = 0
    @buildings.each do |b|
      act_listings       = b.get_listings(@filter_params)
      listings_with_rent = act_listings.with_rent
      b.act_listings     = act_listings
      b.min_price        = listings_with_rent.first.rent rescue nil
      b.max_price        = listings_with_rent.last.rent  rescue nil
      listings_count    += act_listings.size
    end
    listings_count
  end

end
