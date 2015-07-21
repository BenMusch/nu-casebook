class Case < ActiveRecord::Base
  require 'url_validator'

  # Relationships
  has_many :rounds,     dependent: :destroy
  has_many :topicings,  dependent: :destroy
  has_many :topics,     through: :topicings
  has_many :viewers,    through: :rounds
  has_many :sides,      dependent: :destroy
  # Validations
  validates :title, presence: true, length: { maximum: 100 },
            uniqueness: {case_sensitive: false }
  validates :link, presence: true, url: true,
            uniqueness: { case_sensitive: true }
  validates :case_statement, presence: true
  validate  :opp_choice_has_sides
  # Callbacks
  after_save :delete_sides
  # Attrs
  attr_reader :side1, :side2
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
    update_attribute(:speaks, speaks + round.speaks)
    update_stats
  end

  # Collects the properly formatted RFDs from all of this Cases' Rounds
  def rfds
    result = []
    self.rounds.each do |round|
      result << round.format_rfd
    end
    result
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
      update_attribute(:speaks, speaks - round.speaks)
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
      Topic.where(name: n.strip).first_or_create!
    end
  end

  # Does this case have any of the Topics in the passed string?
  def has_topics(names)
    names.split(",").each do |name|
      return true if self.topic_names.include?(name.downcase.strip)
    end
    false
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

  # Sides the first Side of this Case equal to a Side with the passed name
  # TODO replace with nested form
  def side1=(name)
    self.sides << Side.create(name: name)
  end

  # Sides the second Side of this case equal to a Side with the passed name
  # TODO replace with nested form
  def side2=(name)
    self.sides << Side.create(name: name)
  end

  private
    # deletes the sides in this case if the case is no longer opp choice
    def delete_sides
      unless opp_choice?
        self.sides.each do |side|
          side.Delete
        end
      end
    end

    # updates the statistics for this case, done after callback actions
    def update_stats
      times_run = wins + losses
      tight_calls = tight_call_wins + tight_call_losses
      if times_run > 0
        average_speaks = speaks / times_run
        win_percentage = 100 * wins / times_run
        tight_call_percentage = 100 * tight_calls / times_run
        tight_call_win_percentage = 100 * tight_call_wins /
                                          tight_calls unless tight_calls == 0
      else
        average_speaks = win_percentage =
        tight_call_percentage = tight_call_win_percentage = nil
      end
      update_attribute(:average_speaks,            average_speaks)
      update_attribute(:tight_call_win_percentage, tight_call_win_percentage)
      update_attribute(:tight_call_percentage,     tight_call_percentage)
      update_attribute(:win_percentage,            win_percentage)
    end

    # validates that opp_choice cases have sides
    def opp_choice_has_sides
      if opp_choice?
        errors.add(:side1, "must have a name") if side1.blank?
        errors.add(:side2, "must have a name") if side2.blank?
        errors.add(:side1, "can't have the same name as Side 2") if side1 == side2
      end
    end
end
