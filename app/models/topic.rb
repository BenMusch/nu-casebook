class Topic < ActiveRecord::Base
  # Relations
  has_many :topicings
  has_many :excluding_topics
  has_many :including_topics
  has_many :cases,             through: :topicings
  has_many :includes_searches, through: :including_topics, source: 'Search'
  has_many :excludes_searches, through: :excluding_topics, source: 'Search'
  # Callbacks
  before_save :downcase_name

  def downcase_name
    self.name.downcase!
  end
end
