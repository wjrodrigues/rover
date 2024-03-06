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

      it 'returns false if location negative' do
        plateau = described_class.new(width: 20, height: 10)

        expect(plateau.to_move?(x_axis: -1, y_axis: 5)).to be_falsy
      end

      it 'returns false if location not empty' do
        rover = Vehicle::Rover.new(x_axis: 0, y_axis: 10)
        plateau = described_class.new(width: 20, height: 10)
        plateau.add_vehicle!(rover)

        expect(plateau.to_move?(x_axis: 0, y_axis: 10)).to be_falsy
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

  describe '#add_vehicle!?' do
    context 'when the coordinate is invalid' do
      shared_examples 'many languages' do |values|
        values.each do |value|
          it "raise error '#{value[:text]}'", locale: value[:locale] do
            expect { plateau.add_vehicle!(rover) }.to raise_error(value[:text])
          end
        end
      end

      it_behaves_like 'many languages', [
        { locale: :en, text: 'location is not valid' },
        { locale: :'pt-BR', text: 'localização não é válida' }
      ] do
        let(:rover) { build(:rover, x_axis: 22, y_axis: 10) }
        let(:plateau) { described_class.new(width: 20, height: 10) }
      end

      it_behaves_like 'many languages', [
        { locale: :en, text: 'location is not empty' },
        { locale: :'pt-BR', text: 'local não está livre' }
      ] do
        let(:rover) { build(:rover, x_axis: 0, y_axis: 0) }
        let(:plateau) { described_class.new(width: 20, height: 10) }

        before do
          first_rover = Vehicle::Rover.new(x_axis: 0, y_axis: 0)
          plateau.add_vehicle!(first_rover)
        end
      end

      it 'raise error if negative location' do
        rover = Vehicle::Rover.new(x_axis: -1, y_axis: 0)
        plateau = described_class.new(width: 20, height: 10)

        expect { plateau.add_vehicle!(rover) }.to raise_error('location is not valid')
      end
    end

    context 'when the coordinate is valid' do
      it 'adds vehicle on plateau' do
        rover = Vehicle::Rover.new(x_axis: 20, y_axis: 10)
        plateau = described_class.new(width: 20, height: 10)

        plateau.add_vehicle!(rover)

        expect(plateau.vehicles).to eq([rover])
      end

      it 'does not add if present' do
        rover = Vehicle::Rover.new(x_axis: 0, y_axis: 0)
        plateau = described_class.new(width: 20, height: 10)

        plateau.add_vehicle!(rover)
        rover.move
        plateau.add_vehicle!(rover)

        expect(plateau.vehicles).to eq([rover])
      end
    end
  end
end
