class AboutComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :about
  belongs_to :about
end
