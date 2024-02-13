class ApplicationSerializer
  include JSONAPI::Serializer
  attributes :token, :name, :chats_count

end