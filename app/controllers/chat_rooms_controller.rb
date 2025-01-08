class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chat_rooms = ChatRoom.order(created_at: :desc)
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.messages.order(created_at: :asc)
  end

def create
  listing = Listing.find(params[:listing_id])  # Use listing_id instead of id
  seller = listing.user
  buyer = current_user

  Rails.logger.debug "Creating chat room for listing: #{listing.id} - #{listing.title}, Seller: #{seller.id}, Buyer: #{buyer.id}"

  # Ensure a chat room is created for this listing and its participants
  @chat_room = ChatRoom.find_by(listing: listing, name: listing.title)

  unless @chat_room
    # Assign the actual User objects (not IDs) to seller and buyer
    @chat_room = ChatRoom.new(listing: listing, name: listing.title, seller: seller, buyer: buyer)

    if @chat_room.save
      Rails.logger.debug "Chat room created: #{@chat_room.id}"
    else
      Rails.logger.debug "Failed to create chat room: #{@chat_room.errors.full_messages}"
      flash[:error] = "Unable to create chat room."
      return redirect_to listings_path
    end
  else
    Rails.logger.debug "Chat room already exists: #{@chat_room.id}"
  end

  redirect_to chat_room_path(@chat_room)
end




end
