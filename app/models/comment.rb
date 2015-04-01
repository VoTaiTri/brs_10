class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :review
  
  validates :content, presence: true, length: {maximum: 300}

  after_destroy :destroy_activities

  private
  def destroy_activities
    Activity.destroy_all target_id: self.id, action_type: "comment"
  end
end
