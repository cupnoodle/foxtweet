class Relationship < ActiveRecord::Base

  #rails convention will add "_id" after follower
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
