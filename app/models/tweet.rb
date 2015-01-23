class Tweet < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'user_id'

  validates :content, :presence => true, :length => { :maximum => 255}

  scope :latest, lambda{ order("tweets.created_at DESC") }
end
