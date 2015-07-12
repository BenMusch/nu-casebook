class Viewering < ActiveRecord::Base
  belongs_to :round
  belongs_to :viewer
end
