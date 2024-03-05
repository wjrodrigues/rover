# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle::RoverCreator, :service do
  describe '#constants' do
    it { expect(described_class::ERRORS).to be_frozen }

    it do
      expect(described_class::ERRORS).to eq(
        invalid_values: 'values are invalid',
        invalid_location: 'invalid location',
        collision: 'collision route'
      )
    end
  end

  context 'when dto is not valid' do
    let(:area) { Relief::Plateau.new(width: 5, height: 5) }

    it 'returns error if any attribute is null' do
      dto = build(:dto_rover, dimension: nil)

      response = described_class.call(dto:, area:)

      expect(response).not_to be_ok
      expect(response.error).to eq('values are invalid')
    end

    it 'returns error if initial location is invalid' do
      dto = build(:dto_rover)

      dto.inital_position.x_axis = 20

      response = described_class.call(dto:, area:)

      expect(response).not_to be_ok
      expect(response.error).to eq('invalid location')
    end
  end

  context 'when dto is valid' do
    let(:area) { Relief::Plateau.new(width: 5, height: 5) }

    it 'creates rover on area' do
      first_dto = build(:dto_rover)
      second_dto = build(:dto_rover, :second)

      first_response = described_class.call(dto: first_dto, area:)
      expect(first_response).to be_ok

      second_response = described_class.call(dto: second_dto, area:)
      expect(second_response).to be_ok

      first_result = first_response.result
      expect(first_result[:vehicle]).to be_is_a(Vehicle::Rover)
      expect(first_result[:area]).to be_is_a(Relief::Plateau)
      expect(first_result[:vehicle].x_axis).to eq(1)
      expect(first_result[:vehicle].y_axis).to eq(3)
      expect(first_result[:vehicle].orientation).to eq(Vehicle::Rover::NORTH)

      second_result = second_response.result
      expect(second_result[:vehicle]).to be_is_a(Vehicle::Rover)
      expect(second_result[:area]).to be_is_a(Relief::Plateau)
      expect(second_result[:vehicle].x_axis).to eq(5)
      expect(second_result[:vehicle].y_axis).to eq(1)
      expect(second_result[:vehicle].orientation).to eq(Vehicle::Rover::EAST)

      expect(first_result[:area].vehicles).to eq([first_result[:vehicle], second_result[:vehicle]])
      expect(second_result[:area].vehicles).to eq([first_result[:vehicle], second_result[:vehicle]])
    end

    context 'and there is a collision' do
      it 'moves only the first rover' do
        first_dto = build(:dto_rover)
        second_dto = build(:dto_rover)

        first_response = described_class.call(dto: first_dto, area:)
        expect(first_response).to be_ok

        first_result = first_response.result
        expect(first_result[:vehicle]).to be_is_a(Vehicle::Rover)
        expect(first_result[:area]).to be_is_a(Relief::Plateau)
        expect(first_result[:vehicle].x_axis).to eq(1)
        expect(first_result[:vehicle].y_axis).to eq(3)
        expect(first_result[:vehicle].orientation).to eq(Vehicle::Rover::NORTH)
        expect(first_result[:area].vehicles.size).to eq(1)

        second_response = described_class.call(dto: second_dto, area:)
        expect(second_response).not_to be_ok
        expect(second_response.result).to be_nil
        expect(second_response.error).to eq('collision route')
      end
    end
  end
end
