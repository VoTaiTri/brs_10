class Review < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  has_many :comments

  validates :content, presence: true, length: {maximum: 500}
  validates :rating, presence: true, inclusion: {in: 0..10}

  after_destroy :destroy_activities

  private
  def destroy_activities
    Activity.destroy_all target_id: self.id, action_type: "review"
  end
end
