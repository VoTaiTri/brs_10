class Admin::BooksController < AdminController
  helper_method :sort_column, :sort_direction
  respond_to :html, :js

  def index
    @books = Book.search params[:search], params[:filter], params[:category_id]
    @books = @books.order [sort_column, sort_direction].join(' ')
    @books = @books.paginate page: params[:page], per_page: 20
  end

  def new
    @book = Book.new
    @photo = @book.photos.build
  end

  def edit
    @book = Book.find params[:id]
  end

  def create
    @book = Book.new book_params
    
    if @book.save
      flash[:success] = "Book created!"
      redirect_to admin_books_path
    else
      render :new
    end
  end

  def update
    @book = Book.find params[:id]
    if @book.update_attributes book_params
      flash[:success] = "Book updated!"
      redirect_to admin_books_path
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find params[:id]
    Activity.destroy_all(target_id: @book.id, 
        action_type: ["read", "reading", "unread", "favorite", "unfavorite"])
    @book.destroy
  end

  private
  def sort_column
    Book.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end
  
  def book_params
    params.require(:book).permit :title, :image, :author, :number_of_pages, :publish_date, 
                          :category_id, photos_attributes: [:id, :image, :_destroy]
  end
end