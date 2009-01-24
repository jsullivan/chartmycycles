class About < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :about_comments
end
