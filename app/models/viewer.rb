class Viewer < ActiveRecord::Base
  has_many :viewerings
  has_many :cases, through: :viewerings
  validates :name, uniqueness: { case_sensitive: false }

  def ==(other_object)
    other_object.instance_of?(Viewer) &&
        self.name.downcase == other_object.name.downcase
  end
end
