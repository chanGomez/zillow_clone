class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
     @chat_rooms = ChatRoom.all

  if @chat_rooms.any?
    @chat_room = @chat_rooms.first # Use the first chat room or select one logically
    @messages = @chat_room.messages.order(created_at: :asc)
    puts @messages
    @show_messages_view = render_to_string(template: "chat_rooms/show", layout: false, locals: { messages: @messages })
    @Listing = Listing.find(@chat_room.listing_id)  # Use listing_id instead of id



  else
    @show_messages_view = nil
  end
  end

  def show
  @chat_room = ChatRoom.find(params[:id])
  @messages = @chat_room.messages.order(created_at: :asc)

  # Render the 'show' template as a string
  @show_messages_view = render_to_string(template: "chat_rooms/show", layout: false, locals: { messages: @messages })

  # Log the rendered content for debugging
  Rails.logger.debug(@show_messages_view)

  # Optionally respond with JSON if this is for an API or dynamic content rendering
  respond_to do |format|
    format.html # default behavior to render show.html.erb
    format.json { render json: { messages_html: @show_messages_view } }
  end
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
