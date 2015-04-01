class BookStatesController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  def index
    @user = User.find params[:user_id]
    @book_states = BookState.read_history @user
  end

  def new
    @book = Book.find params[:book_id]
    @book_state = BookState.new
  end

  def create
    @book = Book.find params[:book_id]
    @book_state = BookState.new book_state_params
    @book_state.user = current_user
    @book_state.book = @book
    if @book_state.save
      current_user.create_activity @book.id, @book_state.state
    end
  end

  def edit
    @book = Book.find params[:book_id]
    @book_state = BookState.find params[:id]
  end

  def update
    @book = Book.find params[:book_id]
    @book_state = BookState.find params[:id]
    if @book_state.update_attributes book_state_params
      current_user.create_activity @book.id, @book_state.state
    end
  end

  private
  def book_state_params
    params.require(:book_state).permit :state
  end
end
