class Forum < ActiveRecord::Base
  belongs_to :user
  has_many :posts
  validates_presence_of :topic
end
