class Viewer < ActiveRecord::Base
  has_many :viewerings
  has_many :excluding_viewers
  has_many :rounds,   through: :viewerings
  has_many :searches, through: :excluding_viewers
  before_save :capitalize_name

  def capitalize_name
    names = self.name.split(" ").map { |n| n.capitalize }
    self.name = names.join(" ")
  end
end
