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

  describe '#move' do
    context 'when call move a position' do
      it 'moves rover' do
        rover = described_class.new(x_axis: 0, y_axis: 0, orientation: described_class::NORTH)

        expect(rover.orientation).to eq(described_class::NORTH)

        rover.move
        expect(rover.y_axis).to eq(1)

        rover.move_right
        rover.move
        expect(rover.x_axis).to eq(1)

        rover.move_right
        rover.move
        rover.move
        expect(rover.y_axis).to be_zero

        rover.move_right
        rover.move
        rover.move
        expect(rover.x_axis).to be_zero
      end
    end
  end

  describe '#move_left' do
    context 'when the call changes orientation' do
      it 'moves rover' do
        rover = described_class.new(x_axis: 0, y_axis: 2, orientation: described_class::NORTH)

        expect(rover.orientation).to eq(described_class::NORTH)

        rover.move_left
        expect(rover.orientation).to eq(described_class::WEST)

        rover.move_left
        expect(rover.orientation).to eq(described_class::SOUTH)

        rover.move_left
        expect(rover.orientation).to eq(described_class::EAST)

        rover.move_left
        expect(rover.orientation).to eq(described_class::NORTH)
      end
    end
  end

  describe '#move_right' do
    context 'when the call changes orientation' do
      it 'moves rover' do
        rover = described_class.new(x_axis: 0, y_axis: 2, orientation: described_class::NORTH)

        expect(rover.orientation).to eq(described_class::NORTH)

        rover.move_right
        expect(rover.orientation).to eq(described_class::EAST)

        rover.move_right
        expect(rover.orientation).to eq(described_class::SOUTH)

        rover.move_right
        expect(rover.orientation).to eq(described_class::WEST)

        rover.move_right
        expect(rover.orientation).to eq(described_class::NORTH)
      end
    end
  end

  describe '#path' do
    context 'when the rover moves' do
      it 'updates path' do
        rover = described_class.new(x_axis: 0, y_axis: 0)

        expect(rover.path).to eq([])

        rover.move_left
        rover.move
        rover.move_right
        rover.move

        expectd_path = [
          { orientation: 'W', x_axis: 0, y_axis: 0 },
          { orientation: 'N', x_axis: 0, y_axis: 1 }
        ]

        expect(rover.path).to eq(expectd_path)
      end
    end
  end
end
