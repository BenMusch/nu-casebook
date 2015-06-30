class User < ActiveRecord::Base
  before_save { self.email.downcase! }
  VALID_EMAIL_REGEX = /\A(\w)+\.(\w)+@husky.neu.edu/i
  validates :email, presence: true, length: { maximum: 299 },
                    uniqueness: {case_sensitive: false }
  validates_format_of :email, with: VALID_EMAIL_REGEX,
                              message: "must be a @husky.neu.edu email"
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
