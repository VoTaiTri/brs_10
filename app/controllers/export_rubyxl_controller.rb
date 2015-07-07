class ExportRubyxlController < ApplicationController
  def index
    @products = Product.all
    @companies = Company.all
  end

  def new
    @products = Product.all
    @companies = Company.all

    respond_to do |format|
      format.xlsx do
        send_data ExportRubyxl.export_file @products, @companies
      end
    end
  end
end
