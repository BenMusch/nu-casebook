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

  def self.tokens(query)
    viewers = where("name LIKE ?", "%#{query}%")
    if viewers.empty?
      [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
    else
      viewers
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub("/<<<(.+?)>>>/") { create!(name: $1).id }
    tokens.split(',')
  end
end
