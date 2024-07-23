# frozen_string_literal: true

require_relative '../main'

describe Validator do
  describe '#valid_number?' do
    context 'when the input is a valid number' do
      it 'returns true' do
        expect(described_class.valid_number?('3')).to be true
      end
    end

    context 'when the input is not a number' do
      it 'returns false' do
        expect(described_class.valid_number?('a')).to be false
      end
    end

    context 'when the input is a number less than 1' do
      it 'returns false' do
        expect(described_class.valid_number?('0')).to be false
      end
    end

    context 'when the input is a number greater than 5' do
      it 'returns false' do
        expect(described_class.valid_number?('6')).to be false
      end
    end
  end
end
