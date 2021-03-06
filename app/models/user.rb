class User < ApplicationRecord
  include ActiveModel::Validations::HelperMethods
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  rolify
  ratyrate_rater
  acts_as_voter
  
  has_many :reviews
  has_many :buildings
  has_many :units
  has_many :authorizations
  has_many :useful_reviews
  has_many :review_flags
  has_many :billings, dependent: :destroy
  has_many :featured_buildings, dependent: :destroy
  has_many :featured_listings, dependent: :destroy
  has_many :favorites, as: :favoriter, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: [:create, :update]

  DEFAULT_TIMEZONE = 'Eastern Time (US & Canada)'
  US_ZONES         = ['UTC', 'America/Havana']
  
  SOCIALS = {
    facebook:       'Facebook',
    google_oauth2:  'Google',
    linkedin:       'Linkedin'
  }

  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' },
                             :default_url => "/images/:style/user-missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  
  #methods
  def slug_candidates
    [ :name, [:name, :user_email] ]
  end

  def admin?
    has_role? :admin
  end

  def user_email
    email.split('@')[0]
  end

  def set_timezone zone
    zone = DEFAULT_TIMEZONE if US_ZONES.include?(zone)
    update_column(:time_zone, zone)
  end

  def timezone
    time_zone.present? ? time_zone : DEFAULT_TIMEZONE
  end

  def profile_image provider=nil
    provider    = (provider == 'Google' ? 'google_oauth2' : 'facebook')
    auths       = authorizations.where(provider: provider)
    avatar_url  = if auths.present? 
                    auths.last.image_url
                  elsif avatar.present?
                    avatar.url(:medium)
                  else
                    'user-missing.png'
                  end
    
    return avatar_url
  end

  def user_name
    name.present? ? name : email[/[^@]+/]
  end

  def logged_in_user_name
    name.present? ? name : authorizations&.first&.name
  end

  def property_owner? object
    self.id == object.user_id
  end

  def create_rating score, rateable, review_id, dimension=nil
    rateable_klass = rateable.class.name
    rating_caches  = RatingCache.where(cacheable_id: rateable.id, dimension: dimension)
    rateables      = Rate.where(rateable_id: rateable.id, rateable_type: rateable_klass, dimension: dimension)
    # Creating user rating
    Rate.create(rater_id:      self.id,        rateable_id: rateable.id,
                rateable_type: rateable_klass, dimension:   dimension,
                stars:         score,          review_id:   review_id )
    
    # Rating cache
    if rating_caches.present?
      rating_caches.map{ |rc| RatingCache.update_rating_cache(rc) }
    else
      RatingCache.create_rating_cache(rateable, rateables, dimension)
    end
  end

  def get_rating_by property_id, dimension, review_id
    Rate.where(rater_id: self.id, 
               rateable_id: property_id, 
               dimension: dimension, 
               review_id: review_id).first rescue nil
  end

  def user_favorite favorable
    favorites.find_by(favorable_id:    favorable.id, 
                      favorable_type: favorable.class.name)
  end

  def favorite?(favorable)
    user_favorite(favorable).present?
  end  

  def favorite(favorable)
    favorites.create(favorable_id: favorable.id, favorable_type: favorable.class.name) unless favorite?(favorable)
  end

  def unfavorite(favorable)
    user_favorite(favorable).try(:destroy)
  end

  def add_to_fav favorable_id
    favorite(Building.find(favorable_id))
  end

end
