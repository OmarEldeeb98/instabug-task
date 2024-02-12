# == Schema Information
#
# Table name: messages
#
#  id             :bigint           not null, primary key
#  message_number :integer
#  body           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chat_id        :bigint
#
class Message < ApplicationRecord
  belongs_to :chat
end
