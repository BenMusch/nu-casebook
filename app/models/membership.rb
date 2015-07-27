class Membership < ActiveRecord::Base
  belongs_to :round
  belongs_to :member
end
