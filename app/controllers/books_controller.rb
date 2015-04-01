class BooksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: :show

  def index
    @books = Book.search params[:search], params[:filter], params[:category_id]
    @books = @books.order [sort_column, sort_direction].join(' ')
    @books = @books.paginate page: params[:page], per_page: 10
  end

  def show
    @book = Book.find params[:id]
    @book_state = BookState.find_by book: @book, user: current_user
    @reviews = @book.reviews.paginate page: params[:page], per_page: 10
  end

  private
  def sort_column
    Book.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def book_params
    params.require(:book).permit :title, :author
  end
end