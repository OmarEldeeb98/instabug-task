class MessageCreator
  include Sidekiq::Worker
  def perform(message_params)
    message = Message.new(message_params)
    message.save!
    puts "message created"
  end
end