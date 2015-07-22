class Round < ActiveRecord::Base
  include Helpers

  belongs_to :side
  belongs_to :case
  has_many   :viewerings, dependent: :destroy
  has_many   :viewers, through: :viewerings

  validates :case_id, presence: true
  validates :speaks, numericality: { less_than_or_equal_to: 56,
                                     greater_than_or_equal_to: 44 }
  validates :rfd, presence: true, length: { minimum: 10 }


  after_save     :add_round
  before_destroy :delete_round
  before_update  :delete_round

  # Returns a string of the Viewers of this Round, separated by commas
  def viewers_list
    names_string(self.viewers)
  end

  # Sets the Viewers of this Round equal to all the names in the passed string
  def viewers_list=(names)
    self.viewers = names.split(',').map do |n|
      Viewer.where(name: format_name(n.strip)).first_or_create!
    end
  end

  # Formats the rfd into a hash that contains important info
  def format_rfd
    { tight_call: self.tight_call?,
      win:        self.win?,
      text:       self.rfd }
  end

  private
    # Adds this Round's stats to its Case
    def add_round
      self.case.add_round(self)
    end

    # Deletes this Round's stats from its Case
    def delete_round
      self.case.delete_round(self)
    end
end
