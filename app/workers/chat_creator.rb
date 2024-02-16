class ChatCreator
  include Sidekiq::Worker
  def perform(chat_number, application_id)
    chat = Chat.new(chat_number: chat_number, application_id: application_id)
    chat.save!
    puts "chat created"
  end
end