class Round < ActiveRecord::Base
  belongs_to :case
  has_many   :viewerings, dependent: :destroy
  has_many   :viewers, through: :viewerings
  
  validates_presence_of     :case_id, :rfd, :speaks
  validates_numericality_of :speaks, less_than_or_equal_to: 56,
                            greater_than_or_equal_to: 44
  validates_length_of       :rfd, minimum: 10



  def viewers_list
    self.viewers.map(&:name).join(', ')
  end

  def viewers_list=(names)
    self.viewers = names.split(',').map do |n|
      Viewer.where(name: n.strip).first_or_create!
    end
  end
end
