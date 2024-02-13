class AddForeignKeys < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :chat, foreign_key: true
    add_reference :chats, :application, foreign_key: true
  end
end
