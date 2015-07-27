class Case < ActiveRecord::Base
  include Helpers
  require 'url_validator'

  has_many :rounds,     dependent: :destroy
  has_many :topicings,  dependent: :destroy
  has_many :topics,     through: :topicings
  has_many :viewers,    -> { uniq }, through: :rounds
  has_many :sides,      dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 },
            uniqueness: {case_sensitive: false }
  validates :link, presence: true, url: true,
            uniqueness: { case_sensitive: true }
  validates :case_statement, presence: true
  validate do
      force_sides_for_opp_choice
  end

  after_save :delete_sides

  accepts_nested_attributes_for :sides

  # Adds the stats of the passed Round to this Cases' attributes
  def add_round(round)
    if round.win?
      update_attribute(:wins, wins + 1)
      update_attribute(:tight_call_wins, tight_call_wins + 1) if round.tight_call?
    else
      update_attribute(:losses, losses + 1)
      update_attribute(:tight_call_losses, tight_call_losses + 1) if round.tight_call?
    end
    if opp_choice?
      if round.win?
        round.side.update_attribute(:wins, round.side.wins + 1)
      else
        round.side.update_attribute(:losses, round.side.losses + 1)
      end
    end
    if round.speaks
      update_attribute(:speaks, speaks + round.speaks)
      if rounds_with_speaks
        update_attribute(:rounds_with_speaks, rounds_with_speaks + 1)
      else
        update_attribute(:rounds_with_speaks, 1)
      end
    end
    update_stats
  end

  # Collects the properly formatted RFDs from all of this Cases' Rounds
  def rfds(side=nil)
    winning = []
    losing = []
    self.rounds.each do |round|
      next if side && round.side.name != side
      round.win? ? winning << round.format_rfd : losing << round.format_rfd
    end
    [winning, losing]
  end

  # Deletes the stats of the passed Round from this Case
  def delete_round(round)
      if round.win?
        update_attribute(:wins, wins - 1)
        update_attribute(:tight_call_wins,
                         tight_call_wins - 1) if round.tight_call?
      else
        update_attribute(:losses, losses - 1)
        update_attribute(:tight_call_losses,
                         tight_call_losses - 1) if round.tight_call?
      end
      if opp_choice?
        if round.win?
          round.side.update_attribute(:wins, round.side.wins - 1)
        else
          round.side.update_attribute(:losses, round.side.losses - 1)
        end
      end

      if round.speaks
        update_attribute(:speaks, speaks - round.speaks)
        update_attribute(:rounds_with_speaks, rounds_with_speaks - 1)
      end
      update_stats
  end

  # Returns a string of the names of the Topics this Case has, joined by commas
  # Used for forms
  def topic_list
    names_string(self.topics)
  end

  # Returns an array of the names of the Topics this Case has
  # Used for the show page of a Case
  def topic_names
    names_array(self.topics)
  end

  # Sets the Topics for this Case based on a string of comma-separated names
  def topic_list=(names)
    self.topics = names.split(',').map do |n|
      Topic.find_or_create_by(name: n.strip)
    end
  end

  # Does this case have any of the Topics in the passed string?
  def has_topics(names)
    names.split(",").each do |name|
      return true if self.topic_names.include?(name.downcase.strip)
    end
    false
  end

  # Returns stats separated by sides for opp choice cases
  def opp_choice_stats
    final_stats = []
    case_times_run = self.wins + self.losses
    self.sides.find_each do |side|
      times_defended = side.wins + side.losses
      side_stats = Hash.new
      side_stats[:name] = side.name
      if times_defended > 0
        side_stats[:rate_defended] = 100 * times_defended / case_times_run
        side_stats[:win_percentage] = 100 * side.wins / times_defended unless times_defended == 0
      end
      side_stats[:win_percentage] ||= 0
      side_stats[:rate_defended] ||= 0
      final_stats << side_stats
    end
    final_stats
  end

  # Is this case seen by any of the passed names?
  def seen_by(names)
    all_names = self.viewers.map(&:name)
    all_names = all_names.map{|n| n.downcase }
    names.split(",").each do |name|
      all_names.include?(name.downcase.strip)
    end
  end

  # Class method that returns all of the Cases with the passed string in
  # their title
  def self.search(search)
    if search
      where([ 'title LIKE ? OR case_statement LIKE ?', "%#{search}%",
        "%#{search}%" ])
    else
      all
    end
  end

  private
    # deletes the sides in this case if the case is no longer opp choice
    def delete_sides
      unless opp_choice?
        self.sides.each do |side|
          side.delete
        end
      end
    end

    # updates the statistics for this case, done after callback actions
    def update_stats
      times_run = wins + losses
      tight_calls = tight_call_wins + tight_call_losses
      if times_run > 0
        win_percentage = 100 * wins / times_run
        tight_call_percentage = 100 * tight_calls / times_run
        tight_call_win_percentage = 100 * tight_call_wins /
                                          tight_calls unless tight_calls == 0
      else
        win_percentage = 0
        tight_call_percentage = tight_call_win_percentage = 0
      end
      if rounds_with_speaks && rounds_with_speaks > 0
        average_speaks = speaks / rounds_with_speaks
      else
        average_speaks = 0
      end
      update_attribute(:tight_call_win_percentage, tight_call_win_percentage)
      update_attribute(:average_speaks,            average_speaks)
      update_attribute(:tight_call_percentage,     tight_call_percentage)
      update_attribute(:win_percentage,            win_percentage)
    end

    def no_names
      return true if sides.size < 2
      sides.each do |side|
        return true if !side.name.present?
      end
      false
    end

    def same_names
      sides.map(&:name).uniq.size != sides.map(&:name).size
    end

    def force_sides_for_opp_choice
      if opp_choice?
        errors.add(:sides, "must have names") if no_names
        errors.add(:sides, "can't have the same name") if same_names
      end
    end
end
