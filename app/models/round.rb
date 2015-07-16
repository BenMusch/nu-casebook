class Round < ActiveRecord::Base
  belongs_to :case
  has_many   :viewerings, dependent: :destroy
  has_many   :viewers, through: :viewerings

  validates_presence_of     :case_id, :rfd, :speaks
  validates_numericality_of :speaks, less_than_or_equal_to: 56,
                            greater_than_or_equal_to: 44
  validates_length_of       :rfd, minimum: 10

  after_save     :add_round
  before_destroy :delete_round
  before_update  :delete_round

  def viewers_list
    self.viewers.map(&:name).join(', ')
  end

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

  def add_round
    self.case.add_round(self)
  end

  def delete_round
    self.case.delete_round(self)
  end
end
