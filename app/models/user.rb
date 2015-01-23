class User < ActiveRecord::Base

  before_validation :prep_email, :add_avatar

  has_secure_password
  has_many :tweets, dependent: :destroy
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  has_many :followers, through: :follower_relationships
  has_many :followeds, through: :followed_relationships
  

  USERNAME_REGEX = /\A[a-zA-Z0-9]+[a-zA-z0-9-_]+/
  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

  validates :username, :presence => true, :length => { :minimum=> 1, :maximum => 32 }, :format => USERNAME_REGEX, :uniqueness => true
  validates :name, :presence => true, :length => { :minimum=> 1, :maximum => 64 }
  validates :email, :presence => true, :length => { :maximum => 32}, :format => EMAIL_REGEX, :uniqueness => true
  validates :description, :length => { :maximum => 64 }
  validates :password, :presence => true, length: { minimum: 6 }, on: :create
  validates :password, :confirmation => true,
                       :length => { minimum: 6 },
                       :allow_blank => true,
                       :on => :update

  validates :avatar_url, :presence => true, :inclusion => { in: 1..3 }

  scope :sorted, lambda{ order("username ASC") }

  def follow_user(user_id)
    Relationship.create(follower_id: self.id, followed_id: user_id)
  end

  private

  #and add random avatar
  def prep_email
    self.email = self.email.strip.downcase if self.email
  end

  def add_avatar
    rng = Random.new(Time.now.to_i)
    self.avatar_url = rng.rand(1..3)
  end
end
