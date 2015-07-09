class Topicing < ActiveRecord::Base
  belongs_to :topic, dependent: :destroy
  belongs_to :case, dependent: :destroy
end
