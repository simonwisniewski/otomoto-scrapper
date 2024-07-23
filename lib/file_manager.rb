# frozen_string_literal: true

require 'date'
require 'logger'

## FileManager module
module FileManager
  @logger = Logger.new('./logs/file_manager.log', 10, 1_024_000)
  ## Write to file method
  # Writes the data to the file
  def self.write_to_file(file_name, data)
    File.open(file_name, 'w') do |file|
      file.write(data)
    end
    @logger.info("Successfully wrote to file: #{file_name}")
  rescue StandardError => e
    @logger.error("Failed to write to file: #{file_name}. Error: #{e.message}")
    raise e
  end

  ## Read from file method
  # Reads the data from the file
  def read_from_file(file_name)
    data = File.read(file_name)
    @logger.info("Successfully read from file: #{file_name}")
    data
  rescue StandardError => e
    @logger.error("Failed to read from file: #{file_name}. Error: #{e.message}")
    raise
  end
end
