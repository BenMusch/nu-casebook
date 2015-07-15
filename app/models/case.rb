class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.include?(' ')
      record.errors[attribute] << "can't can't have spaces"
    elsif !(value =~ /https?:\/\/[\S]+/i)
      message = "must be a valid URL starting with http:// or https://"
      record.errors[attribute] << message
    end
  end
end

class Case < ActiveRecord::Base
  has_many :rounds,     dependent: :destroy
  has_many :topicings,  dependent: :destroy
  has_many :topics,     through: :topicings
  has_many :viewers,    through: :rounds

  validates :title, presence: true, length: { maximum: 100 },
            uniqueness: {case_sensitive: false }
  validates :link, presence: true, url: true,
            uniqueness: { case_sensitive: true }
  validates :case_statement, presence: true

  def stats
    rfds = []
    viewers = []
    self.rounds.each do |round|
      rfds << [round.win, round.rfd]
    end
    times_run = self.wins + self.losses
    if times_run == 0
      avg_speaks = 0
      win_percentage = 0
    else
      avg_speaks = self.speaks / times_run
      win_percentage = 100 * self.wins / times_run
    end
    { times_run: times_run,
      win_percentage: win_percentage,
      avg_speaks: avg_speaks,
      rfds: rfds,
      viewers: viewers }
  end

  def topic_list
    self.topics.map(&:name).join(', ')
  end

  def topic_names
    self.topics.map(&:name)
  end

  def topic_list=(names)
    self.topics = names.split(',').map do |n|
      Topic.where(name: n.strip).first_or_create!
    end
  end

  def has_topics(names)
    names.split(",").each do |name|
      return true if self.topic_names.include?(name.downcase.strip)
    end
    false
  end

  def seen_by(names)
    all_names = self.viewers.map(&:name)
    all_names = all_names.map{|n| n.downcase }
    names.split(",").each do |name|
      all_names.include?(name.downcase.strip)
    end
  end

  def self.search(search)
    if search
      where([ 'title LIKE ? OR case_statement LIKE ?', "%#{search}%",
        "%#{search}%" ])
    else
      all
    end
  end
end
