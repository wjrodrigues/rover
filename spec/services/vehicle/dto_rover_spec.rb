# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle::DtoRover, :dto do
  describe '#new' do
    context 'when params are valid' do
      it 'returns parsed values' do
        values = ['5   5', '1  2    N', 'LMLMLMLMM']

        rover = described_class.new(values)

        expect(rover.dimension.to_h).to eq(width: '5', height: '5')
        expect(rover.inital_position.to_h).to eq(x_axis: '1', y_axis: '2', orientation: 'N')
        expect(rover.moviments).to eq(%w[L M L M L M L M M])
      end
    end

    context 'when params are invalid' do
      it 'does not parse values' do
        values = ['55', '12    N', 'LMLM LMLMM']

        rover = described_class.new(values)

        expect(rover.dimension).to be_nil
        expect(rover.inital_position).to be_nil
        expect(rover.moviments).to be_nil
      end
    end
  end
end
