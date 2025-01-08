class ListingsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]#renders devise template to sign user in. 
  # before_action :set_listing, except: [:index, :new, :create]
  
def index
  @listings = Listing.includes(:comments).order(created_at: :desc)

  # Filter by search term if provided
  if params[:search_term].present?
    @listings = @listings.search_by_location(params[:search_term])
  end

  # Filter by price range if provided=
  if params[:min_price].present?
    @listings = @listings.where("price >= ?", params[:min_price].to_f)
  end
  if params[:max_price].present?
    @listings = @listings.where("price <= ?", params[:max_price].to_f)
  end
end

  def show
    @listing = Listing.includes(:comments).find(params[:id])
    @user = @listing.user
    p @listing.longitude
    p @listing.latitude
  end

  def new
    @listing = Listing.new
  end

def create
  @listing = Listing.new(listing_params)
  puts @listing
  @listing.user_id = current_user.id # Explicitly set the user_id

  if @listing.save
    redirect_to @listing, notice: "Listing was successfully created."
  else
    render :new, status: :unprocessable_entity
  end
end


  def update
    if @listing.update(listing_params)
      redirect_to @listing
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.destroy
    redirect_to root_path, notice: "Listing was successfully deleted."
  end

  private

  def search
    if params[:search_term].present?
      @listings = Listing.search_by_location(params[:search_term])
    end
  end

  def listing_params
  params.require(:listing).permit(:title, :description, :price, :location, :latitude, :longitude, images: [])
  end

  # def set_listing
  #   @listing = user_signed_in? ? Listing.find(params[:id]) : Listing.published.find(params[:id])
  #  #if in case of an error or in this case an id that does not exit in the db then send user to home page
  # rescue ActiveRecord::RecordNotFound
  #     redirect_to root_path 
  # #root_path is => "/"
  # end

end