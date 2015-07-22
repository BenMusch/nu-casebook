class Side < ActiveRecord::Base
  belongs_to :case
  has_many   :rounds
end
