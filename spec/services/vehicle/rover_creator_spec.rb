# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle::RoverCreator, :service do
  describe '#constants' do
    it { expect(described_class::ERRORS).to be_frozen }

    it do
      expect(described_class::ERRORS).to eq(
        invalid_values: 'services.creator.invalid_values',
        invalid_location: 'services.creator.invalid_location',
        collision: 'services.creator.collision',
        error_processing: 'services.creator.error_processing'
      )
    end
  end

  context 'when dto is not valid' do
    let(:area) { Relief::Plateau.new(width: 5, height: 5) }

    shared_examples 'many languages' do |values|
      values.each do |value|
        it "returns error '#{value[:text]}'", locale: value[:locale] do
          response = described_class.call(dto:, area:)

          expect(response).not_to be_ok
          expect(response.error).to eq(value[:text])
        end
      end
    end

    it_behaves_like 'many languages', [
      { locale: :en, text: 'values are invalid' },
      { locale: :'pt-BR', text: 'os valores são inválidos' }
    ] do
      let(:dto) { build(:dto_rover, dimension: nil) }
    end

    it_behaves_like 'many languages', [
      { locale: :en, text: 'invalid location' },
      { locale: :'pt-BR', text: 'localização inválida' }
    ] do
      let(:dto) do
        build(:dto_rover) { |dto| dto.inital_position.x_axis = 20 }
      end
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
      let(:first_dto) { build(:dto_rover) }
      let(:second_dto) { build(:dto_rover) }

      it 'moves only the first rover locale: :en' do
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

      it 'moves only the first rover locale: :pt-BR', locale: :'pt-BR' do
        described_class.call(dto: first_dto, area:)
        response = described_class.call(dto: second_dto, area:)

        expect(response.error).to eq('em rota de colisão')
      end
    end
  end

  context 'when raise error' do
    let(:dto) { build(:dto_rover) }

    it 'calls Tracker::Track locale: :en' do
      expect(dto).to receive(:dimension).and_raise(StandardError)
      expect(Tracker::Track).to receive(:notify).with(StandardError)

      response = described_class.call(dto:, area: nil)

      expect(response).not_to be_ok
      expect(response.error).to eq('error when processing information')
    end

    it 'calls Tracker::Track locale: :pt-BR', locale: :'pt-BR' do
      expect(dto).to receive(:dimension).and_raise(StandardError)

      response = described_class.call(dto:, area: nil)

      expect(response.error).to eq('erro ao processar informações')
    end
  end
end
