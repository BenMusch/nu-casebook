class Topicing < ActiveRecord::Base
  belongs_to :topic
  belongs_to :case
end
