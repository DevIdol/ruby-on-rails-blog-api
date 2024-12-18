class BlacklistToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
end
