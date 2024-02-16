class CountersUpdater
  include Sidekiq::Worker
  def perform()
    keys = Redis.keys
    for key in keys do
      if key.start_with?("app#")
        application_token = key.split('#')[1]
        application = Application.find_by!(token: application_token)
        application.update_columns({chats_count: Redis.get(key)})
      elsif key.start_with?("chat#")
        splitted_key = key.split('#')
        application_token = splitted_key[1]
        chat_number = splitted_key[2]
        application_id = Application.find_by!(token: application_token).id
        chat = Chat.find_by!(application_id: application_id, chat_number: chat_number)
        chat.update_columns({messages_count: Redis.get(key)})
      end
    end
    puts "counters updated"
  end
end