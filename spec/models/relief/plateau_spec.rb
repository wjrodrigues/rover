# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relief::Plateau, :model do
  describe 'validations' do
    let(:subject) { described_class.new(width: 20, height: 10) }

    it { should validate_numericality_of(:height).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:width).only_integer.is_greater_than(0) }
  end

  describe '#new' do
    context 'when height and width are invalid' do
      it 'raise error' do
        expect { described_class.new(height: 10.5, width: 20) }.to raise_error(NoMatchingPatternError)
      end
    end
  end

  describe '#dimensions' do
    it 'returns dimension' do
      plateau = described_class.new(width: 20, height: 10)

      expect(plateau.dimension).to eq({ width: 20, height: 10 })
    end
  end

  describe '#to_move?' do
    context 'when the coordinate is invalid' do
      it 'raise error' do
        plateau = described_class.new(width: 20, height: 10)

        expect { plateau.to_move?(x_axis: 10.2, y_axis: 5) }.to raise_error(NoMatchingPatternError)
      end
    end

    context 'when the coordinate is valid' do
      it 'returns true if in the area' do
        plateau = described_class.new(width: 20, height: 10)

        expect(plateau.to_move?(x_axis: 2, y_axis: 5)).to be_truthy
      end

      it 'returns true if in the area' do
        plateau = described_class.new(width: 20, height: 10)

        expect(plateau.to_move?(x_axis: 22, y_axis: 5)).to be_falsy
        expect(plateau.to_move?(x_axis: 5, y_axis: 12)).to be_falsy
      end
    end
  end
end
