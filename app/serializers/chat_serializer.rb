class ChatSerializer
  include JSONAPI::Serializer
  attributes :messages_count
  attribute :messages do |object|
    object.messages.pluck(:message_number)
  end

end