# frozen_string_literal: true

## Product class
# Represents a product
class Product
  ## Initialize method
  # Initializes the Product object
  # @param attributes [Hash] the product attributes
  def initialize(attributes)
    @name = attributes[:name]
    @engine = attributes[:engine]
    @power = attributes[:power]
    @description = attributes[:description]
    @price = attributes[:price]
    @image_url = attributes[:image_url]
    @product_url = attributes[:product_url]
    @year = attributes[:year]
    @fuel = attributes[:fuel]
    @gearbox = attributes[:gearbox]
    @mileage = attributes[:mileage]
    @location = attributes[:location]
  end

  ## Show method
  # returns the hash of the product attributes
  def show
    {
      'name' => @name,
      'engine' => @engine,
      'power' => @power,
      'description' => @description,
      'price' => @price,
      'image_url' => @image_url,
      'product_url' => @product_url,
      'year' => @year,
      'fuel' => @fuel,
      'gearbox' => @gearbox,
      'mileage' => @mileage,
      'location' => @location
    }
  end
end
