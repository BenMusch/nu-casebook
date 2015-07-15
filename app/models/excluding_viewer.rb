class ExcludingViewer < ActiveRecord::Base
  belongs_to :viewer
  belongs_to :search
end
