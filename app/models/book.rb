class Book < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :book_states, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :photos, dependent: :destroy

  validates :title, presence: true, length: {maximum: 100}
  validates :publish_date, presence: true
  validates :author, presence: true, length: {maximum: 150}
  validates :number_of_pages, presence: true
  validates :category, presence: true

  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true

  mount_uploader :image, PictureUploader

  after_destroy :destroy_activities

  def self.search(search, filter, category)
    if search
      if category.blank?
        where("#{filter} LIKE ?", "%#{search}%")
      else
        where("category_id = ? AND #{filter} LIKE ?", "#{category}", "%#{search}%")
      end
    else
      all
    end
  end

  def state user
    book_state = BookState.find_by book: self, user: user
    book_state.nil? ? "unread" : book_state.state
  end

  def average_rating
    self.reviews.average :rating
  end

  private
  def destroy_activities
    Activity.destroy_all target_id: self.id, action_type: ["read", "reading", 
                                          "unread", "favorite", "unfavorite"]
  end
end