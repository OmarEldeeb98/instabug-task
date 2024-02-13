class ChangeMessageBodyToText < ActiveRecord::Migration[7.1]
  def change
    change_column :messages, :body, :text
    change_column :applications, :chats_count, :integer, :default => 0
    change_column :chats, :messages_count, :integer, :default => 0
  end
end
