class ChatRoom < ApplicationRecord
  belongs_to :listing
  has_many :messages, dependent: :destroy
  # has_many :users
  # belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  # belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
    belongs_to :seller, class_name: 'User'
  belongs_to :buyer, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates :listing_id, presence: true
  validates :name, presence: true
  validates :seller_id, presence: true
  validates :buyer_id, presence: true
end
