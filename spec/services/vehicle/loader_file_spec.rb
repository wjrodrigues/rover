# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle::LoaderFile, :service do
  describe '#constants' do
    it { expect(described_class::LIMIT_FILE_SIZE).to eq(100) }
    it { expect(described_class::ERRORS).to be_frozen }

    it do
      expect(described_class::ERRORS).to eq(
        {
          invalid_path: 'file not found',
          invalid_format: 'unsupported format',
          large_file: 'file size is invalid',
          invalid_content: 'file content is not valid'
        }
      )
    end
  end

  context 'when path is invalid' do
    it "returns error 'file not found'" do
      path = ''

      response = described_class.call(path:)

      expect(response).not_to be_ok
      expect(response.error).to eq('file not found')
    end

    it "returns error 'unsupported format'" do
      path = 'spec/fixtures/files/lib/file/reader.csv'

      response = described_class.call(path:)

      expect(response).not_to be_ok
      expect(response.error).to eq('unsupported format')
    end

    it "returns error 'file size is invalid'" do
      path = 'spec/fixtures/services/vehicle/loader_file.txt'
      stub_const('Vehicle::LoaderFile::LIMIT_FILE_SIZE', 1)

      response = described_class.call(path:)

      expect(response).not_to be_ok
      expect(response.error).to eq('file size is invalid')
    end

    it "returns error 'file content is not valid'" do
      path = 'spec/fixtures/files/lib/file/reader.txt'

      response = described_class.call(path:)

      expect(response).not_to be_ok
      expect(response.error).to eq('file content is not valid')
    end
  end

  context 'when path is valid' do
    it 'returns result with DdtRover' do
      path = 'spec/fixtures/services/vehicle/loader_file.txt'
      expected_dtos = [build(:dto_rover), build(:dto_rover, :second)]

      response = described_class.call(path:)

      expect(response).to be_ok

      first_dto = response.result.first
      second_dto = response.result.last

      expect(first_dto.dimension).to eq(expected_dtos[0].dimension)
      expect(first_dto.inital_position).to eq(expected_dtos[0].inital_position)
      expect(first_dto.movement).to eq(expected_dtos[0].movement)

      expect(second_dto.dimension).to eq(expected_dtos[1].dimension)
      expect(second_dto.inital_position).to eq(expected_dtos[1].inital_position)
      expect(second_dto.movement).to eq(expected_dtos[1].movement)
    end
  end
end
