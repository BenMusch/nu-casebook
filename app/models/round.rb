class Round < ActiveRecord::Base
  belongs_to :case
  validates_presence_of :case_id, :rfd, :speaks
  validates_numericality_of :speaks, less_than_or_equal_to: 56,
                            greater_than_or_equal_to: 44
  validates_length_of :rfd, minimum: 10
end
