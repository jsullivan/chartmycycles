class Avatar < ActiveRecord::Base
  has_attachment :content_type => :image, 
                   :storage => :file_system, 
                   :max_size => 500.kilobytes,
                   :resize_to => '180',
                   :processor => :MiniMagick,
                   :thumbnails => { :thumb => '40x40>', :medium => '80x80>' }

    validates_as_attachment
    belongs_to :user
end
