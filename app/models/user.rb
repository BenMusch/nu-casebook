class NotSethValidator < ActiveModel::EachValidator
  def validate_each(person, attribute, value)
    if value == 'goldstein.se@husky.neu.edu'
      person.errors[attribute] << "can't belong to a traitor. Nice try, Seth."
    elsif !(value =~ /\A(\w)+\.(\w)+@husky.neu.edu/i)
      person.errors[attribute] << "must be a @husky.neu.edu address"
    end
  end
end

class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email.downcase! }
  validates :email, presence: true, length: { maximum: 299 },
                    uniqueness: {case_sensitive: false },
                    not_seth: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns a hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets this user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
