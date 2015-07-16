class Topic < ActiveRecord::Base
  has_many :topicings
  has_many :excluding_topics
  has_many :including_topics
  has_many :cases,             through: :topicings
  has_many :includes_searches, through: :including_topics, source: 'Search'
  has_many :excludes_searches, through: :excluding_topics, source: 'Search'
  before_save :downcase_name

  def downcase_name
    self.name.downcase!
  end

  def self.tokens(query)
    topics = where("name LIKE ?", "%#{query}%")
    if topics.empty?
      [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
    else
      topics
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub("/<<<(.+?)>>>/") { create!(name: $1).id }
    tokens.split(',')
  end
end
