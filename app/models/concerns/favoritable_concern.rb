module FavoritableConcern
	extend ActiveSupport::Concern
	included do
		has_many :favorites, as: :favorable, dependent: :destroy
	end

  def favorite_by?(favoriter)
    return user_favorites(favoriter).size > 0
  end

  def user_favorites favoriter
    favorites.where(favoriter_id:   @favoriter.id, 
                    favoriter_type: @favoriter.class.base_class.name)
  end

  def fav_color_class user_id = nil
    if user_id.present?
      favorite_by?(User.find(user_id)) ? 'filled-heart' : 'unfilled-heart'
    else
      'unfilled-heart'
    end 
  end
end