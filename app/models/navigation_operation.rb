class NavigationOperation < ActiveRecord::Base
  validates_presence_of :operation_id, :navigation_id, :time_to_execute
end
