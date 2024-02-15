# == Schema Information
#
# Table name: chats
#
#  id             :bigint           not null, primary key
#  messages_count :integer          default(0)
#  chat_number    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :bigint
#
class Chat < ApplicationRecord

  validates :chat_number, presence: true, uniqueness: { scope: :application_id }


  belongs_to :application
  has_many :messages
end
