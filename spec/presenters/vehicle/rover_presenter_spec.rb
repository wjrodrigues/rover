# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle::RoverPresenter, :presenter do
  describe '#result' do
    context 'when it is a vehicle' do
      it 'returns formatted result' do
        vehicle = build(:rover, :south)
        expected = { x: 1, y: 3, orientation: 'S' }

        presenter = described_class.new(vehicle:)

        expect(presenter.result).to eq(expected)
        expect(presenter.result(format: :json)).to eq(JSON.pretty_generate(expected))
      end
    end

    context 'when there are many vehicles' do
      it 'returns formatted result' do
        vehicle = build_list(:rover, 2)

        expected = [
          { x: 1, y: 3, orientation: 'N' },
          { x: 1, y: 3, orientation: 'N' }
        ]

        presenter = described_class.new(vehicle:)

        expect(presenter.result).to eq(expected)
        expect(presenter.result(format: :json)).to eq(JSON.pretty_generate(expected))
      end
    end

    context 'when has error' do
      it 'returns formatted result with error' do
        vehicle = build(:rover, :south)
        expected = { x: 1, y: 3, orientation: 'S', errors: 'any' }
        errors = 'any'

        presenter = described_class.new(vehicle:, errors:)

        expect(presenter.result).to eq(expected)
        expect(presenter.result(format: :json)).to eq(JSON.pretty_generate(expected))
      end

      context 'and vehicle is empty' do
        it 'returns formatted result with error' do
          expected = { errors: 'any' }
          errors = 'any'
          presenter = described_class.new(vehicle: [], errors:)

          expect(presenter.result).to eq(expected)
          expect(presenter.result(format: :json)).to eq(JSON.pretty_generate(expected))
        end
      end
    end
  end
end
