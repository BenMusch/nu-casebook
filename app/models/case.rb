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

  def add_round(round)
    if round.win?
      update_attribute(:wins, wins + 1)
      update_attribute(:tight_call_wins, tight_call_wins + 1) if round.tight_call?
    else
      update_attribute(:losses, losses + 1)
      update_attribute(:tight_call_losses, tight_call_losses + 1) if round.tight_call?
    end
    update_attribute(:speaks, speaks + round.speaks)
    update_stats
  end

  def rfds
    result = []
    self.rounds.each do |round|
      result << round.format_rfd
    end
    result
  end

  def delete_round(round)
      if round.win?
        update_attribute(:wins, wins - 1)
        update_attribute(:tight_call_wins, tight_call_wins - 1) if round.tight_call?
      else
        update_attribute(:losses, losses - 1)
        update_attribute(:tight_call_losses, tight_call_losses - 1) if round.tight_call?
      end
      update_attribute(:speaks, speaks - round.speaks)
      update_stats
  end

  def update_stats
    times_run = wins + losses
    tight_calls = tight_call_wins + tight_call_losses
    if times_run > 0
      average_speaks = speaks / times_run
      win_percentage = 100 * wins / times_run
      tight_call_percentage = 100 * tight_calls / times_run
      tight_call_win_percentage = 100 * tight_call_wins / tight_calls unless tight_calls == 0
    else
      average_speaks = win_percentage = tight_call_percentage = tight_call_win_percentage = nil
    end
    update_attribute(:average_speaks,            average_speaks)
    update_attribute(:tight_call_win_percentage, tight_call_win_percentage)
    update_attribute(:tight_call_percentage,     tight_call_percentage)
    update_attribute(:win_percentage,            win_percentage)
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
