class Sender < ActiveRecord::Base
  validates_presence_of :facebook_id
  validates :facebook_id, uniqueness: true
end
