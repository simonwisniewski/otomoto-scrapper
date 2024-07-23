# frozen_string_literal: true

require_relative './product'
require_relative './file_manager'
require 'wicked_pdf'
require 'csv'
require 'logger'

## ProductReportGenerator class
# Generates a report in HTML, PDF or CSV format
class ProductReportGenerator
  include FileManager

  ## Initialize method
  # Initializes the ProductReportGenerator object
  # @param products [Array] the products
  def initialize(products, brand)
    @products = products
    @html = ''
    @brand = brand
    @logger = Logger.new('./logs/product_report_generator.log', 10, 1_024_000)
  end

  ## Generate html method
  # Generates a report in the html format
  def generate_html
    @logger.info('Starting HTML report generation...')
    css = read_from_file('./styles.css')
    @html += "<html><head><style>#{css}</style><meta charset='utf-8'><title>Product Catalog</title></head><body>"
    @html += "<div class='title'>
      <img src='https://statics.otomoto.pl/optimus-storage/a/otomotopl/images/logo.svg' alt='otomoto' />
      <h1>Scrap results for: #{@brand.capitalize}</h1>
    </div>"
    @html += '<ul>'
    @products.each_with_index do |product, _index|
      product_details = product.show
      @html += '<li>'
      @html += "<img src='#{product_details['image_url']}' alt='#{product_details['name']}' />"
      @html += "<div class='description'>"
      @html += "<div class='header'>"
      @html += '<article>'
      @html += "<h2>#{product_details['name']}</h2>"
      @html += "<p>#{product_details['description']}</p>"
      @html += '</article>'
      @html += '</div>'
      @html += "<div class='details'>"
      @html += "<p><span>Rok produkcji: </span>#{product_details['year']}</p>"
      @html += "<p><span>Pojemność: </span>#{product_details['engine']}</p>"
      @html += "<p><span>Moc: </span>#{product_details['power']}</p>"
      @html += "<p><span>Typ paliwa: </span>#{product_details['fuel']}</p>"
      @html += "<p><span>Skrzynia: </span>#{product_details['gearbox']}</p>"
      @html += "<p><span>Przebieg: </span>#{product_details['mileage']}</p>"
      @html += "<p><span>Lokalizacja: </span>#{product_details['location']}</p>"
      @html += "</div'>"
      @html += '</div>'
      @html += "<h1 style='text-align:right; width:100%;'>#{product_details['price']} zł</h1>"
      @html += "<a href='#{product_details['product_url']}' target='_blank'><div class='link'><p>Product details</p></div></a>"
      @html += '</li>'
    end
    @html += '</ul>'
    @html += '</body></html>'
    FileManager.write_to_file('./reports/products.html', @html)
    @logger.info('HTML report successfully generated and saved to products.html.')
    @html
  end

  ## Generate pdf method
  # Generates a report in the pdf format using the wicked_pdf gem
  def generate_pdf
    @logger.info('Starting PDF report generation...')
    @html = generate_html
    wicked_pdf = WickedPdf.new
    pdf_file = wicked_pdf.pdf_from_string(@html, {
                                            page_size: 'A4',
                                            print_media_type: true,
                                            disable_smart_shrinking: true,
                                            no_background: false
                                          })
    FileManager.write_to_file('./reports/products.pdf', pdf_file)
    @logger.info('PDF report successfully generated and saved to products.pdf.')
  end

  ## Generate csv method
  # Generates a report in the csv format
  def generate_csv
    @logger.info('Starting CSV report generation...')
    CSV.open('./reports/products_report.csv', 'wb', write_headers: true,
                                                    headers: %w[Name Description Year Engine Power Price Fuel Mileage Location]) do |csv|
      @products.each do |product|
        product_details = product.show
        csv << [
          product_details['name'],
          product_details['description'],
          product_details['year'],
          product_details['engine'],
          product_details['power'],
          product_details['price'],
          product_details['fuel'],
          product_details['mileage'],
          product_details['location']
        ]
      end
      @logger.info('CSV report successfully generated and saved to products_report.csv.')
    end
  end
end
