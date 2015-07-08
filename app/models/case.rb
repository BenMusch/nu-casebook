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
  has_many :rounds, dependent: :destroy
  has_many :topicings
  has_many :topics, through: :topicings
  validates :title, presence: true, length: { maximum: 100 },
            uniqueness: {case_sensitive: false }
  validates :link, presence: true, url: true,
            uniqueness: { case_sensitive: true }
  validates :case_statement, presence: true

  def stats
    wins = 0
    losses = 0
    speaks = 0
    rfds = []
    self.rounds.each do |round|
      round.win ? wins += 1 : losses += 1
      speaks += round.speaks
      rfds << [round.win, round.rfd]
    end
    times_run = wins + losses
    if times_run == 0
      avg_speaks = "N/A"
      win_percentage = "N/A"
    else
      avg_speaks = speaks / times_run
      win_percentage = 100 * wins / times_run
    end
    { times_run: times_run,
      win_percentage: win_percentage,
      avg_speaks: avg_speaks,
      rfds: rfds }
  end

  def topic_list
    self.topics.map(&:name)
  end

  def topic_list=(names)
    self.topics = names.split(",").map do |n|
      Topic.where(name: n).first_or_create!
    end
  end
end
