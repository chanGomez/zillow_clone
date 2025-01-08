class Listing < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :location_changed?

  belongs_to :user
  has_many :chat_rooms
  has_many_attached :images
  has_many :comments, dependent: :destroy
  validate :acceptable_images


  scope :search_by_location, ->(query) {
    where("location LIKE ?", "%#{query}%")
  }

  scope :filter_by_price_range, ->(min, max) {
    where("price >= ?", min).where("price <= ?", max) if min.present? && max.present?
  }


  def acceptable_images
    return unless images.attached?

    if images.size > 15
      errors.add(:images, "cannot exceed 5 files")
    end

    images.each do |image|
      unless image.content_type.in?(%w[image/jpeg image/png])
        errors.add(:images, "must be a JPEG or PNG")
      end

      if image.byte_size > 5.megabytes
        errors.add(:images, "must be less than 5 MB")
      end
    end
  end
end
