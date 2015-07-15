class Search < ActiveRecord::Base
  has_many :includes_topics, through: :excluding_topics, source: 'Topic'
  has_many :excludes_topics, through: :including_topics, source: 'Topic'
  has_many :viewers,         through: :excluding_viewers
  has_many :including_topics
  has_many :excluding_topics
  has_many :excluding_viewers
  validates_numericality_of :min_speaks, greater_than_or_equal_to: 44,
                            less_than_or_equal_to: 56,
                            allow_blank: true
  validates_numericality_of :min_wins, greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100,
                            allow_blank: true
  validates_numericality_of :min_tight_call, greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100,
                            allow_blank: true
  validates_numericality_of :max_tight_call, greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100,
                            allow_blank: true
end
