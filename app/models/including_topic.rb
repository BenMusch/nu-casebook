class IncludingTopic < ActiveRecord::Base
  belongs_to :topic
  belongs_to :search
end
