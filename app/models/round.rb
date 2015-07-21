class Round < ActiveRecord::Base

  # Relationships
  belongs_to :case
  has_many   :viewerings, dependent: :destroy
  has_many   :viewers, through: :viewerings
  # Validations
  validates_presence_of     :case_id, :rfd, :speaks
  validates_numericality_of :speaks, less_than_or_equal_to: 56,
                            greater_than_or_equal_to: 44
  validates_length_of       :rfd, minimum: 10
  # Callbacks
  after_save     :add_round
  before_destroy :delete_round
  before_update  :delete_round

  # Returns a string of the Viewers of this Round, separated by commas
  def viewers_list
    self.viewers.map(&:name).join(', ')
  end

  # Sets the Viewers of this Round equal to all the names in the passed string
  def viewers_list=(names)
    self.viewers = names.split(',').map do |n|
      Viewer.where(name: n.strip).first_or_create!
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
