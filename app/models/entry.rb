class Entry < ActiveRecord::Base

belongs_to :user
belongs_to :cycle
has_one :insomnia_comment
has_one :acne_comment
has_one :bloating_comment
has_one :cervix_comment
has_one :cramp_comment
has_one :intercourse_comment
has_one :moody_comment
has_one :peak_comment
has_one :period_comment
has_one :temp_comment
has_one :vaginal_sensation_comment
end
