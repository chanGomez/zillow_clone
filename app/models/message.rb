class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  after_create_commit { broadcast_message }
    validates :content, presence: true

  private

  def broadcast_message
    MessageChannel.broadcast_to(chat_room, {
      message: self.content,
      user: self.user.name,
      created_at: self.created_at.strftime('%H:%M')
    })
  end

end