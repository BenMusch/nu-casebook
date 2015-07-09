class Topicing < ActiveRecord::Base
  belongs_to :topic
  belongs_to :case, dependent: :destroy
end
