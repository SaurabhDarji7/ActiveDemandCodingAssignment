class Client < ApplicationRecord
  has_many :cards
  enum :status, { active: 0, banned: 1 }

  validates :ip_address, presence: true, uniqueness: true
  validates :status, presence: true

  def ban!
    raise 'Client is already banned' if banned?

    update!(status: 'banned')
  end
end