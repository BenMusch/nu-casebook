class Topic < ActiveRecord::Base
  has_many :topicings
  has_many :cases, through: :topicings
  before_save :downcase_name

  def downcase_name
    self.name.downcase!
  end
end
