class Topic < ActiveRecord::Base
  has_many :topicings
  has_many :cases, through: :topicings
  validates :name, unqiueness: { case_sensitive: false }
end
