class Viewer < ActiveRecord::Base
  # Relations
  has_many :viewerings
  has_many :excluding_viewers
  has_many :rounds,   through: :viewerings
  has_many :cases,    through: :rounds
  has_many :searches, through: :excluding_viewers
  # Validations
  validates_uniqueness_of :name, case_sensitive: false
  # Callbacks
  before_save :capitalize_name

  def capitalize_name
    self.name = format_name(self.name)
  end
end
