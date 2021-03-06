# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string
#  uid        :string
#  user_id    :integer
#  token      :string
#  secret     :string
#  name       :string
#  image_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Authorization < ApplicationRecord
	belongs_to :user
	validates :user_id, presence: true
end
