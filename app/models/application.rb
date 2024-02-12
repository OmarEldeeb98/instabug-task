# == Schema Information
#
# Table name: applications
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  chats_count :integer          default(0)
#  token       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Application < ApplicationRecord
  # associations
  has_many :chats
  
  # callbacks
  before_create :ensure_token

  def ensure_token
    self.token ||= loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Application.exists?(token: random_token)
    end
  end
end
