class Round < ActiveRecord::Base
  include Helpers

  belongs_to :side
  belongs_to :case, touch: true
  has_many   :memberships, dependent: :destroy
  has_many   :viewerings, dependent: :destroy
  has_many   :viewers, through: :viewerings
  has_many   :members, through: :memberships

  validates :speaks, numericality: { less_than_or_equal_to: 56,
                                     greater_than_or_equal_to: 44,
                                     allow_blank: true }
  validates :rfd, presence: true, length: { minimum: 10 }

  after_save     :add_round
  before_update  :delete_round
  before_destroy  :delete_round

  # Returns a string of the Viewers of this Round, separated by commas
  def viewers_list
    names_string(self.viewers)
  end

  # Sets the Viewers of this Round equal to all the names in the passed string
  def viewers_list=(names)
    self.viewers = names.split(',').map do |n|
      Viewer.find_or_create_by(name: format_name(n.strip))
    end
  end

  # Returns a string of the Viewers of this Round, separated by commas
  def members_list
    names_string(self.members)
  end

  # Sets the Viewers of this Round equal to all the names in the passed string
  def members_list=(names)
    self.members = names.split(',').map do |n|
      Member.find_or_create_by(name: format_name(n.strip))
    end
  end

  # Formats the rfd into a hash that contains important info
  def format_rfd
    rfd_hash = Hash.new
    rfd_hash[:tight_call] = tight_call?
    rfd_hash[:win]        = win?
    rfd_hash[:text]       = rfd
    rfd_hash[:side]       = side if side
    rfd_hash
  end

  private
    # Adds this Round's stats to its Case
    def add_round
      self.case.add_round(self)
    end

    # Deletes this Round's stats from its Case
    def delete_round
      round = Round.new
      round.assign_attributes(self.attributes)
      round.assign_attributes(self.changed_attributes)
      self.case.delete_round(round)
    end
end
