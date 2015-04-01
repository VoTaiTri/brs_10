class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!,  only: [:destroy, :edit, :update]
  respond_to :js

  def create
    @review = Review.find params[:review_id]
    @comment = Comment.new comment_params
    @comment.user = current_user
    @comment.review = @review
    if @comment.save
      current_user.create_activity @comment.id, "comment"
    end
  end

  def destroy
    @review = Review.find params[:review_id]
    @comment = Comment.find params[:id]
    Activity.destroy_all target_id: @comment.id, action_type: "comment"
    @comment.destroy
  end

  def update
    @review = Review.find params[:review_id]
    @comment = Comment.find params[:id]
    @comment.update_attributes comment_params
  end

  private
    def comment_params
      params.require(:comment).permit :content
    end

    def correct_user!
      @comment = current_user.comments.find_by id: params[:id]
      redirect_to root_url if @comment.nil?
    end
end