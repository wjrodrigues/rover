# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle::Processor, :service do
  describe '#constants' do
    it { expect(described_class::ERRORS).to be_frozen }

    it do
      expect(described_class::ERRORS).to eq(
        error_processing: 'services.processor.error_processing'
      )
    end
  end

  context 'when file is valid' do
    it 'creates vehicles on area' do
      path_file = 'spec/fixtures/services/vehicle/loader_file.txt'

      response = described_class.call(path_file:)

      expect(response).to be_ok
      expect(response.result).to be_is_a(Relief::Plateau)
      expect(response.result.vehicles.size).to eq(2)
    end
  end

  context 'when the file is invalid' do
    it 'does not creates vehicle' do
      path_file = ''

      response = described_class.call(path_file:)

      expect(response).not_to be_ok
      expect(response.error).to eq('file not found')
      expect(response.result).to be_nil
    end
  end

  context 'when raise error' do
    it 'calls Tracker::Track locale: :en' do
      loader = double('Vehicle::LoaderFile')
      path_file = 'spec/fixtures/services/vehicle/loader_file.txt'

      expect(loader).to receive(:call).and_raise(StandardError)
      expect(Tracker::Track).to receive(:notify).with(StandardError)

      response = described_class.call(path_file:, loader:)

      expect(response).not_to be_ok
      expect(response.error).to eq('error when processing information')
    end

    it 'calls Tracker::Track locale: :pt-BR', locale: :'pt-BR' do
      loader = double('Vehicle::LoaderFile')
      path_file = 'spec/fixtures/services/vehicle/loader_file.txt'

      expect(loader).to receive(:call).and_raise(StandardError)

      response = described_class.call(path_file:, loader:)

      expect(response.error).to eq('erro ao processar informações')
    end
  end
end
