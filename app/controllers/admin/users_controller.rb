class Admin::UsersController < AdminController
  helper_method :sort_column, :sort_direction
  respond_to :html, :js

  def index
    @users = User.all.search_by(params[:search]).order(sort_column + ' ' + sort_direction)
    @users = @users.paginate page: params[:page], per_page: 10
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
  end

  private
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def user_params
    params.require(:user).permit :name, :avatar
  end
end