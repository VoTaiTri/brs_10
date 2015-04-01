class FavoritesController < ApplicationController
  before_action :authenticate_user!, except: :index
  respond_to :js

  def index
    @user = User.find params[:user_id]
    @favorites = Favorite.user_favorite @user
  end

  def create
    @favorite = Favorite.new favorite_params
    @favorite.user = current_user
    if @favorite.save
      current_user.create_activity @favorite.book.id, "favorite"
    end
  end

  def destroy
    @favorite = Favorite.find params[:id]
    current_user.create_activity @favorite.book.id, "unfavorite"
    @favorite.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def favorite_params
    params.require(:favorite).permit :book_id
  end
end
