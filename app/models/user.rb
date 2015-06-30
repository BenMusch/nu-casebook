class User < ActiveRecord::Base
  before_save { self.email.downcase! }
  VALID_EMAIL_REGEX = /\A(\w)+\.(\w)+@husky.neu.edu/i
  validates :email, presence: true, length: { maximum: 299 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
