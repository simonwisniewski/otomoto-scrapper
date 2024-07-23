# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/scrapper'

describe Scrapper do
  describe '#scrap' do
    context 'when the target is volkswagen' do
      it 'retrieves data successfully' do
        scrapper = described_class.new('https://www.otomoto.pl/osobowe/volkswagen', 1)
        data = scrapper.scrap
        expect(data).not_to be_empty
      end
    end

    context 'when the target is audi' do
      it 'retrieves data successfully' do
        scrapper = described_class.new('https://www.otomoto.pl/osobowe/audi', 1)
        data = scrapper.scrap
        expect(data).not_to be_empty
      end
    end

    context 'when the target is bmw' do
      it 'retrieves data successfully' do
        scrapper = described_class.new('https://www.otomoto.pl/osobowe/bmw', 1)
        data = scrapper.scrap
        expect(data).not_to be_empty
      end
    end

    context 'when the target is mercedes-benz' do
      it 'retrieves data successfully' do
        scrapper = described_class.new('https://www.otomoto.pl/osobowe/mercedes-benz', 1)
        data = scrapper.scrap
        expect(data).not_to be_empty
      end
    end

    context 'when the target is nissan' do
      it 'retrieves data successfully' do
        scrapper = described_class.new('https://www.otomoto.pl/osobowe/nissan', 1)
        data = scrapper.scrap
        expect(data).not_to be_empty
      end

      it 'correctly retrieves data across multiple pages' do
        scrapper = described_class.new('https://www.otomoto.pl/osobowe/nissan', 3)
        data = scrapper.scrap
        expect(data.count).to be > 40
      end
    end
  end
end
