# == Schema Information
#
# Table name: reviews
#
#  id               :integer          not null, primary key
#  review_title     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  building_id      :integer
#  user_id          :integer
#  reviewable_id    :integer
#  reviewable_type  :string
#  building_address :string
#  tenant_status    :string
#  resident_to      :string
#  pros             :string
#  cons             :string
#  other_advice     :string
#  anonymous        :boolean          default(FALSE)
#  tos_agreement    :boolean          default(FALSE)
#  resident_from    :string
#  scraped          :boolean          default(FALSE)
#

class Review < ApplicationRecord
	resourcify
  belongs_to :reviewable, polymorphic: true, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :useful_reviews
  has_many :review_flags
  
  include Imageable
  include PgSearch
  
  validates :tos_agreement, :allow_nil => false, :acceptance => { :accept => true }, :on => :create #, message: 'Terms not accepted.'
  
  after_destroy :destroy_dependents

  default_scope { order('created_at DESC') }

  pg_search_scope :search_query, against: [:review_title, :pros, :cons],
     :using => { :tsearch => { prefix: true } }

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  def self.buildings_reviews buildings
    where(reviewable_id: buildings.map(&:id), 
          reviewable_type: 'Building').includes(:user, :uploads, :reviewable)
  end

  #reviewer
  def user_name
  	self.user.name ? self.user.name : self.user.email[/[^@]+/]
  end

  def user_votes?
    user.votes.where(vote: true, review_id: id).present?
  end

  def marked_useful? user
    useful_reviews.where(user_id: user.id).present?
  end

  def marked_flag? user
    review_flags.where(user_id: user.id).present?
  end

  def property_name
    if reviewable_object.kind_of? Building
      reviewable_object.name ? reviewable_object.name : reviewable_object.building_street_address
    elsif reviewable_object.kind_of? Unit
      reviewable_object.name
    end
  end

  def reviewable_object
    self.reviewable
  end

  def property_address
    if reviewable_object.kind_of? Building
      "#{reviewable_object.street_address} #{reviewable_object.zipcode}"
    elsif reviewable_object.kind_of? Unit
      "#{reviewable_object.building.street_address} #{reviewable_object.building.zipcode}"
    end
  end

  def set_votes vote, current_user, reviewable
    @vote  = if vote == 'true'
              current_user.vote_for(reviewable)
            else
              current_user.vote_against(reviewable)
            end
    @vote.update(review_id: id) if @vote.present?
  end

  def set_score score_hash, reviewable, current_user
    score_hash.keys.each do |dimension|
      # params[dimension] => score
      current_user.create_rating(score_hash[dimension], reviewable, id, dimension)
    end
  end

  def set_imageable uid
    Upload.where(file_uid: uid).update_all(imageable_id: self.id, imageable_type: 'Review')
  end

  private
  # To remove rating and votes
  def destroy_dependents
    Vote.where(review_id: self.id).destroy_all
    rate = Rate.where(review_id: self.id).destroy_all
    # update stars
    rating_caches = RatingCache.where(cacheable_id: self.reviewable_id, cacheable_type: self.reviewable_type)
    
    # updating avg ratign for all dimensions
    rating_caches.map{ |rc| RatingCache.update_rating_cache(rc) }
  end

end
