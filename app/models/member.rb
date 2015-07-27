class Member < ActiveRecord::Base
  include Helpers

  # Relations
  has_many :memberships
  has_many :rounds, through: :memberships
  # Validations
  validates_uniqueness_of :name, case_sensitive: false
  # Callbacks
  before_save :capitalize_name

  def capitalize_name
    self.name = format_name(self.name)
  end
end
