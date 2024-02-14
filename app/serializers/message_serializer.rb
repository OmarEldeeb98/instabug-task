class MessageSerializer
  include JSONAPI::Serializer
  attributes :message_number, :body
end