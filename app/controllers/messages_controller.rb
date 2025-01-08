class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [:create]

  def create
    @message = @chat_room.messages.new(message_params)
    @message.user = current_user

    if @message.save
      redirect_to chat_room_path(@chat_room), notice: "Message sent."
    else
      render 'chat_rooms/show'
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find_by(id: params[:chat_room_id])
    unless @chat_room
      flash[:alert] = "Chat room not found"
      redirect_to listings_path
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
