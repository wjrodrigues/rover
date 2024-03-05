# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Files::Reader, :lib do
  let(:reader) do
    reader = described_class.new('spec/fixtures/files/lib/file/reader.txt')

    reader.open!
  end

  describe '#open!' do
    context 'when file is valid' do
      it 'does not raise error' do
        reader = described_class.new('spec/fixtures/files/lib/file/reader.txt')

        expect { reader.open! }.not_to raise_error
      end
    end

    context 'when file is invalid' do
      it 'raise error InvalidPhat' do
        reader = described_class.new('')

        expect { reader.open! }.to raise_error(Files::Error::InvalidPhat)
      end

      it 'raise error InvalidExtension' do
        reader = described_class.new('spec/fixtures/files/lib/file/reader.csv')

        expect { reader.open! }.to raise_error(Files::Error::InvalidExtension)
      end
    end
  end

  describe '#line' do
    context 'when the file is open' do
      it 'returns current line' do
        expect(reader.line).to be_nil

        %w[1 2 3 4 5].each do |n|
          reader.readline
          expect(reader.line).to eq(n)
        end
      end
    end
  end

  describe '#readline' do
    context 'when the file is open' do
      it 'return null when finishing file' do
        5.times.each do |_|
          expect(reader.readline).not_to be_nil
        end

        expect(reader.line).to eq('5')
        expect(reader.readline).to be_nil
      end
    end
  end
end
