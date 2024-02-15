# == Schema Information
#
# Table name: messages
#
#  id             :bigint           not null, primary key
#  message_number :integer
#  body           :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chat_id        :bigint
#
class Message < ApplicationRecord
  include Searchable

  validates :message_number, presence: true, uniqueness: { scope: :chat_id }

  belongs_to :chat

  settings do
    mapping dynamic: false do
      indexes :chat_id, type: :long
      indexes :body, type: :text, analyzer: 'english'
      indexes :message_number, type: 'integer'
    end
  end

  def self.search(text, chat_id)
    query = {
      query: {
        bool: {
          must: [
            { wildcard: { body: "*#{text}*" } }
          ],
          filter: [
            { term: { chat_id: chat_id } }
          ]
        }
      },
      _source: ["body", "message_number"]
    }
    __elasticsearch__.search(query).records.to_a.map do |record|
      { body: record['body'], message_number: record['message_number'] }
    end
  end
end
