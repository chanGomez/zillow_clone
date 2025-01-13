class RatingsController < ApplicationController
  before_action :set_listing, only: [:create]

  def create
    @rating = @listing.ratings_received.new(rating_params)
    @rating.rater = current_user
    @rating.owner = @listing.user

    if @rating.save
      redirect_to listing_path(@listing), notice: 'Rating submitted successfully!'
    else
      redirect_to listing_path(@listing), alert: 'Failed to submit rating.'
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def rating_params
    params.require(:rating).permit(:rating)
  end
end
