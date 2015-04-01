class Admin::UsersController < AdminController
  helper_method :sort_column, :sort_direction
  respond_to :html, :js

  def index
    @users = User.search_by(params[:search]).order [sort_column, sort_direction].join(' ')
    @users = @users.paginate page: params[:page], per_page: 10
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]
    Activity.destroy_all(target_id: @user.id,
        action_type: ["follow", "unfollow"])
    @user.destroy
  end

  private
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def user_params
    params.require(:user).permit :name, :avatar
  end
end