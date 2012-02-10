class Post < ActiveRecord::Base

attr_accessible :song, :likes, :user_id

belongs_to :user

end
