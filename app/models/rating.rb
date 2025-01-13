class Rating < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :rater, class_name: 'User', foreign_key: 'user_id'

  validates :rating, presence: true, inclusion: { in: 1..5 }

  # Calculate average rating for the owner
  def self.average_rating_for(user)
    where(owner: user).average(:rating).to_f.round(2)
  end
end
