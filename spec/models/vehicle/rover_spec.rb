# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle::Rover, :model do
  describe 'validations' do
    it { should validate_numericality_of(:x_axis).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:y_axis).only_integer.is_greater_than(0) }
  end

  describe '#new' do
    context 'when x and y axis are valid or missing' do
      it 'creates object with defined axis' do
        rover = described_class.new(x_axis: 5, y_axis: 3)

        expect(rover.x_axis).to eq(5)
        expect(rover.y_axis).to eq(3)
      end

      it 'creates object with default axis' do
        rover = described_class.new

        expect(rover.x_axis).to eq(0)
        expect(rover.y_axis).to eq(0)
      end
    end

    context 'when x and y axis are invalid' do
      it 'raise error' do
        expect { described_class.new(x_axis: '5', y_axis: 3) }.to raise_error(NoMatchingPatternError)
      end
    end
  end

  describe '#position' do
    it 'returns current position' do
      rover = described_class.new(x_axis: 5, y_axis: 3)

      expect(rover.position).to eq(x_axis: 5, y_axis: 3)
    end
  end

  describe '#move_x_axis' do
    context 'when call move a position' do
      it 'moves rover' do
        rover = described_class.new(x_axis: 5, y_axis: 3)

        rover.move_x_axis

        expect(rover.x_axis).to eq(6)

        rover.move_x_axis

        expect(rover.x_axis).to eq(7)
      end
    end
  end

  describe '#move_y_axis' do
    context 'when call move a position' do
      it 'moves rover' do
        rover = described_class.new(x_axis: 5, y_axis: 3)

        rover.move_y_axis

        expect(rover.y_axis).to eq(4)

        rover.move_y_axis

        expect(rover.y_axis).to eq(5)
      end
    end
  end

  describe '#path' do
    context 'when the rover moves' do
      it 'updates path' do
        rover = described_class.new(x_axis: 5, y_axis: 3)

        expect(rover.path).to eq([])

        rover.move_y_axis
             .move_x_axis

        expect(rover.path).to eq([{ x_axis: 5, y_axis: 4 }, { x_axis: 6, y_axis: 4 }])
      end
    end
  end
end
