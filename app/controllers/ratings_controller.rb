class RatingsController < ApplicationController
  before_action :find_owner, only: [:create]

  def create
     
    @owner = Listing.find(params[:listing_id])

    @rating = @owner.ratings_received.new(rating_params)
    @rating.rater = current_user
    @rating.owner_id = @owner.user_id

    if @rating.save
      puts 'Rating submitted successfully!'
    else
      puts 'Failed to submit rating.'
    end
  end

  private

  def find_owner
    foundOwner = Listing.find(params[:listing_id])
    @owner = foundOwner.user_id
  end

  def rating_params
    params.require(:rating).permit(:rating)
  end
end
