class BlacklistedClient < ApplicationRecord
  validates :ip_address, presence: true, unique: true
end