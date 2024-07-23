# frozen_string_literal: true

require 'logger'
require_relative './lib/scrapper'

logger = Logger.new('./logs/main.log', 10, 1_024_000)

## Validator module
# Contains the valid_number? method
module Validator
  ## Valid number method
  # Checks if the input is a positive number between 1 and 5
  def self.valid_number?(input)
    input.match?(/^\d+$/) && input.to_i.between?(1, 5)
  end
end

if __FILE__ == $PROGRAM_NAME
  ## Brands hash
  # Contains the links to the brands
  brands = {
    '1' => 'https://www.otomoto.pl/osobowe/volkswagen',
    '2' => 'https://www.otomoto.pl/osobowe/audi',
    '3' => 'https://www.otomoto.pl/osobowe/bmw',
    '4' => 'https://www.otomoto.pl/osobowe/mercedes-benz',
    '5' => 'https://www.otomoto.pl/osobowe/nissan'
  }

  puts 'Welcome to Otomoto scrapper!'
  puts 'Choose one of the following brands: '
  puts '1. Volkswagen'
  puts '2. Audi'
  puts '3. BMW'
  puts '4. Mercedes-Benz'
  puts '5. Nissan'

  choice = gets.chomp
  if !brands.key?(choice)
    puts 'Invalid input. Please choose a number from 1 to 5.'
    logger.error("Invalid input [#{choice}]. Please choose a number from 1 to 5.")
    exit
  end

  brand = brands[choice]

  puts 'Choose the number of pages to scrap: '
  npage = gets.chomp
  if !Validator.valid_number?(npage)
    puts 'Invalid input. Please provide a positive number that is less than 5.'
    logger.error("Invalid input [#{npage}]. Please provide a positive number that is less than 5.")
    exit
  end

  ## Scrapper object
  # Scrapes the otomoto.pl website for car offers
  # and stores them in an array of Product objects
  # It can also generate a report in HTML, PDF or CSV format by calling the ProductReportGenerator
  scrapper = Scrapper.new(brand, npage.to_i)
  system 'clear'
  puts 'Scraping...'
  begin
    scrapper.scrap
    scrapper.generate_pdf
    scrapper.generate_csv
  rescue StandardError => e
    logger.error("Error while scraping: #{e}")
    puts 'An error occurred while scraping. Please check the logs for more information.'
    exit
  end
  puts 'Scraping finished!'

end
