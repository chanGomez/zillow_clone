class Listing < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :location_changed?

  belongs_to :user
end
