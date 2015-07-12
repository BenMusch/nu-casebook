class Viewer < ActiveRecord::Base
  has_many :viewerings
  has_many :rounds, through: :viewerings
  before_save :capitalize_name

  def capitalize_name
    names = self.name.split(" ").map { |n| n.capitalize }
    self.name = names.join(" ")
  end
end
