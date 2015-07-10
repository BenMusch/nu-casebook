class Viewering < ActiveRecord::Base
  belongs_to :case
  belongs_to :viewer
end
