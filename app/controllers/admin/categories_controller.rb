class Admin::CategoriesController < AdminController
  before_action :set_category, only: [:edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  respond_to :html, :js

  def index
    @categories = Category.search_by params[:search]
    @categories = @categories.order [sort_column, sort_direction].join(' ')
    @categories = @categories.paginate page: params[:page], per_page: 5
  end

  def new
    @title = "New Category"
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = "Category created!"
    else
      flash[:danger] = "Create false!"
    end
    redirect_to admin_categories_path
  end

  def edit
    @title = "Edit #{@category.content}"
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = "Category updated!"
    else
      flash[:danger] = "Update false!"
    end  
    redirect_to edit_admin_category_path @category
  end

  def destroy
    @category.destroy
  end

  private
  def sort_column
    Category.column_names.include?(params[:sort]) ? params[:sort] : "content"
  end

  def set_category
    @category = Category.find params[:id]
  end

  def category_params
    params.require(:category).permit :content, :image
  end
end