class Activity < ActiveRecord::Base
  belongs_to :user
  has_many :likes, dependent: :destroy 
  
  validates :target_id, presence: true
  validates :action_type, presence: true

  scope :user_activity, -> user {where(user_id: user.following_ids + [user.id])}

  before_save :set_message

  private
  def set_message
    self.message = "#{self.user.name}"
    case self.action_type
    when "review"
      review = Review.find self.target_id
      self.message = self.message + " write a review on #{review.book.title}"
    when "comment"
      comment = Comment.find self.target_id
      self.message = self.message + " commented on a post: #{comment.content}"
    when "follow"
      followed_user = User.find self.target_id
      self.message = self.message + " is following #{followed_user.name}"
    when "unfollow"
      unfollow_user = User.find self.target_id
      self.message = self.message + " unfollowed #{unfollow_user.name}"
    when "read", "reading", "unread"
      book = Book.find self.target_id
      self.message = self.message + " marked #{book.title} as #{self.action_type}"
    when "favorite"
      book = Book.find self.target_id
      self.message = self.message + " add #{book.title} to favorite list"
    when "unfavorite"
      book = Book.find self.target_id
      self.message = self.message + " remove #{book.title} from favorite list"
    when "request"
      request = Request.find self.target_id
      self.message = self.message + " sent a new request: #{request.book_name}"
    end
  end

end
