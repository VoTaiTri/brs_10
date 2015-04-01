class Request < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :book_name, presence: true, length: {maximum: 140}
  validates :author, presence: true, length: {maximum: 70} 
  validates :state, presence: true 

  after_destroy :destroy_activities

  private
  def destroy_activities
    Activity.destroy_all target_id: self.id, action_type: "request"
  end
end
