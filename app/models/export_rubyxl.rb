class ExportRubyxl < ActiveRecord::Base
  require "rubyXL"
  def self.export_file products, companies
    workbook = RubyXL::Workbook.new

    sheet1 = workbook[0]
    sheet1.sheet_name = "Product"
    sheet1.add_cell(0, 0, "ID")
    sheet1.add_cell(0, 1, "Name")
    sheet1.add_cell(0, 2, "Price")
    sheet1.sheet_data[0][0].change_font_bold(true)
    sheet1.sheet_data[0][1].change_font_bold(true)
    sheet1.sheet_data[0][2].change_font_bold(true)

    products.each_with_index do |product, num|
      sheet1.add_cell(num + 1, 0, product.id)
      sheet1.add_cell(num + 1, 1, product.name)
      sheet1.add_cell(num + 1, 2, product.price)
    end
    
    last = products.count + 1
    sheet1.add_cell(last, 2, "Total")
    sheet1.sheet_data[last][2].change_font_bold(true)
    sheet1.add_cell(last + 1, 2, "", "SUM(C2:C#{last})")

    sheet2 = workbook.add_worksheet("Company")
    sheet2.add_cell(0, 0, "ID")
    sheet2.add_cell(0, 1, "Name")
    sheet2.add_cell(0, 2, "Address")
    sheet2.sheet_data[0][0].change_font_bold(true)
    sheet2.sheet_data[0][1].change_font_bold(true)
    sheet2.sheet_data[0][2].change_font_bold(true)

    companies.each_with_index do |company, num|
      sheet2.add_cell(num + 1, 0, company.id)
      sheet2.add_cell(num + 1, 1, company.name)
      sheet2.add_cell(num + 1, 2, company.address)
    end

    workbook.stream.string
  end
end
                                                                                                  