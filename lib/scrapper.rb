# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require 'wicked_pdf'
require 'logger'
require_relative './product'
require_relative './product_report_generator'
require_relative './file_manager'

## Scrapper class
# Scrapes the otomoto.pl website for car offers
# and stores them in an array of Product objects
# It can also generate a report in HTML, PDF or CSV format by calling the ProductReportGenerator
class Scrapper
  include FileManager

  ## Initialize method
  # Initializes the Scrapper object with a website link and the number of pages to scrape.
  # @param link [String] the link to the otomoto.pl website.
  # @param npage [Integer] the number of pages to scrape, defaults to 4.
  def initialize(link, npage = 4)
    @link = link
    @products = []
    @npage = npage
    @logger = Logger.new('./logs/scrapper.log', 10, 1_024_000)
  end

  ## Scrap method
  # Scrapes the otomoto.pl website for car offers
  # and stores them in an array of Product objects
  # @return [Array] the array of Product objects
  def scrap
    (1..@npage).each do |page|
      @logger.info("Scraping page #{page}...")
      page_link = "#{@link}?page=#{page}"

      begin
        response = HTTParty.get(page_link,
                                { headers: { 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' } })
      rescue StandardError => e
        @logger.error("Error while fetching the page: #{e}")
        raise e
      end
      document = Nokogiri::HTML(response.body)
      html_products = document.xpath('//article[@data-highlighted="true"]')

      if html_products.empty?
        @logger.warn("No products found on page #{page}")
        break
      end

      html_products.each do |html_product|
        product = extract_product_data(html_product)
        @products.push(product)
      end
    end
    @products
  end

  ## Extract product data method
  # Extracts the product data from the HTML product element
  # @param html_product [Nokogiri::XML::Element] the HTML product element
  def extract_product_data(html_product)
    @logger.debug('Starting to extract product data...')
    url = fetch_xpath_text(html_product, './/h1/a', 'href')
    image = fetch_xpath_text(html_product, './/img', 'src', default: 'No image')
    image = image.gsub(';s=320x240', '') if image != 'No image'
    name = fetch_xpath_text(html_product, './/h1/a')
    engine_description_text = fetch_xpath_text(html_product, './/p')
    engine, power, description = parse_engine_description(engine_description_text)
    year = fetch_xpath_text(html_product, './/dd[@data-parameter="year"]')
    fuel = fetch_xpath_text(html_product, './/dd[@data-parameter="fuel_type"]')
    price = fetch_xpath_text(html_product, './/h3')
    gearbox = fetch_xpath_text(html_product, './/dd[@data-parameter="gearbox"]')
    mileage = fetch_xpath_text(html_product, './/dd[@data-parameter="mileage"]')
    location = fetch_xpath_text(html_product, './/dl[2]/dd[1]/p')

    if url.nil? || name.nil? || year.nil? || price.nil?
      @logger.warn('Missing essential product data: URL, name, year, or price is nil')
      return nil
    end

    Product.new({
                  product_url: url,
                  image_url: image,
                  name: name,
                  engine: engine,
                  power: power,
                  description: description,
                  year: year.to_i,
                  fuel: fuel,
                  price: price,
                  gearbox: gearbox,
                  mileage: mileage,
                  location: location
                })
  rescue StandardError => e
    @logger.error("Failed to extract product data: #{e}")
    nil
  end

  ## Fetch XPath text method
  # Fetches the text of the first element found by the XPath
  def fetch_xpath_text(element, xpath, attribute = nil, default: nil)
    node = element.xpath(xpath).first
    if node.nil?
      @logger.warn("No node found for XPath: '#{xpath}'")
      return default
    end

    if attribute
      if node[attribute]
        node[attribute]
      else
        @logger.warn("Attribute '#{attribute}' not found for node on XPath: '#{xpath}'")
        default
      end
    else
      node.text.strip
    end
  rescue StandardError => e
    @logger.error("Error in fetch_xpath_text for XPath: '#{xpath}', Attribute: '#{attribute}', Error: #{e}")
    default
  end

  ## Parse engine description method
  # Parses the engine description text into engine, power and description
  def parse_engine_description(engine_description_text)
    if engine_description_text.nil? || engine_description_text.strip.empty?
      @logger.warn('Engine description text is empty or nil.')
      return [nil, nil, nil]
    end

    parts = engine_description_text.split(' • ').map(&:strip)
    if parts.length < 3
      @logger.warn("Engine description text does not contain all expected parts: '#{engine_description_text}'")
    end

    parts.fill(nil, parts.length...3)
    @logger.debug("Engine description parsed: Engine: #{parts[0]}, Power: #{parts[1]}, Description: #{parts[2]}")
    parts
  rescue StandardError => e
    @logger.error("Error parsing engine description: '#{engine_description_text}', Error: #{e}")
    [nil, nil, nil]
  end

  ## Show products method
  # Shows the products in the console
  def show_products
    @products.each do |product|
      product.show.each do |key, value|
        puts "#{key.capitalize}: #{value}"
      end
      puts '==========================='
    end
  end

  ## Generate html report method
  # Calls the ProductReportGenerator to generate a report in the html format
  def generate_html
    @logger.info('Generating HTML report...')
    creator = ProductReportGenerator.new(@products, @link.split('/').last)
    creator.generate_html
    @logger.info('HTML report generation completed.')
  rescue StandardError => e
    @logger.error("Failed to generate HTML report: #{e.message}")
    raise e
  end

  ## Generate pdf report method
  # Calls the ProductReportGenerator to generate a report in the pdf format
  def generate_pdf
    @logger.info('Generating PDF report...')
    creator = ProductReportGenerator.new(@products, @link.split('/').last)
    creator.generate_pdf
    @logger.info('PDF report generation completed.')
  rescue StandardError => e
    @logger.error("Failed to generate PDF report: #{e.message}")
    raise e
  end

  ## Generate csv report method
  # Calls the ProductReportGenerator to generate a report in the csv format
  def generate_csv
    @logger.info('Generating CSV report...')
    creator = ProductReportGenerator.new(@products, @link.split('/').last)
    creator.generate_csv
    @logger.info('CSV report generation completed.')
  rescue StandardError => e
    @logger.error("Failed to generate CSV report: #{e.message}")
    raise e
  end
end
