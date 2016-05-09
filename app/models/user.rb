class User < ActiveRecord::Base
  require 'not_seth_validator'
  # Relations
  has_many :rounds
  has_many :topicings
  has_many :topics, through: :topicings
  has_many :cases
  # Validations
  validates     :email, presence: true, length: { maximum: 255 },
                        uniqueness: {case_sensitive: false },
                        not_seth: true
  validates     :password, presence: true, length: { minimum: 6 }

  # Callbacks
  before_save   :downcase_email
  before_create :create_activation_digest
  # Attrs
  attr_accessor :remember_token, :activation_token, :reset_token
  has_secure_password

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
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates this user
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends an activation email to this user
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def owner?(kase)
    kase.user_id == self.id
  end

  def full_access?
    cases.where("visibility != 0").count >= 1
  end

  # Creates a reset digest for the user
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends a password reset email to this user
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Has the password reset expired?
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    # Makes the email all lowercase
    def downcase_email
      self.email.downcase!
    end

    # Creates and assigns the activation token and digest
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
