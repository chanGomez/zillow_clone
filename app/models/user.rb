class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :listings, dependent: :destroy
  has_many :ratings_given, class_name: 'Rating', foreign_key: 'user_id', dependent: :destroy
  has_many :ratings_received, class_name: 'Rating', foreign_key: 'owner_id', dependent: :destroy

  def average_rating
    ratings_received.average(:rating)&.round(2) || 0
  end
end
