class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :requests, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :book_states, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: {maximum: 100}        
  validates :role, presence: true, length: {maximum: 50}
  
  mount_uploader :avatar, PictureUploader

  scope :search_by, ->name {where('name LIKE ?', "%#{name}%")}

  after_destroy :destroy_activities

  def is_admin?
    role == 'admin'
  end

  def is_user? user
    self == user
  end

  def favorite? book
    !self.favorites.find_by(book: book).nil?
  end

  def like? activity
    !self.likes.find_by(activity: activity).nil?
  end
  
  def follow other_user
    self.create_activity other_user.id, "follow"
    active_relationships.create followed_id: other_user.id
  end

  def unfollow other_user
    self.create_activity other_user.id, "unfollow"
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end

  def to_param
    [id, name.parameterize].join("-")
  end

  def following_ids
    self.following.pluck :id
  end

  def create_activity target_id, action_type
    Activity.create user: self, target_id: target_id, action_type: action_type
  end

  private
  def destroy_activities
    Activity.destroy_all target_id: self.id, action_type: ["follow", "unfollow"]
  end
end