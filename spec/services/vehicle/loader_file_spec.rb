# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle::LoaderFile, :service do
  describe '#constants' do
    it { expect(described_class::LIMIT_FILE_SIZE).to eq(100) }
    it { expect(described_class::ERRORS).to be_frozen }

    it do
      expect(described_class::ERRORS).to eq(
        {
          invalid_path: 'services.loader.invalid_path',
          invalid_format: 'services.loader.invalid_format',
          large_file: 'services.loader.large_file',
          invalid_content: 'services.loader.invalid_content'
        }
      )
    end
  end

  context 'when path is invalid' do
    shared_examples 'many languages' do |values|
      values.each do |value|
        it "returns error '#{value[:text]}'", locale: value[:locale] do
          response = described_class.call(path: value[:path])

          expect(response).not_to be_ok
          expect(response.error).to eq(value[:text])
        end
      end
    end

    it_behaves_like 'many languages', [
      { locale: :en, text: 'file not found', path: '' },
      { locale: :'pt-BR', text: 'arquivo não encontrado', path: '' }
    ]

    it_behaves_like 'many languages', [
      { locale: :en, text: 'unsupported format', path: 'spec/fixtures/files/lib/file/reader.csv' },
      { locale: :'pt-BR', text: 'formato não suportado', path: 'spec/fixtures/files/lib/file/reader.csv' }
    ]

    it_behaves_like 'many languages', [
      { locale: :en, text: 'file size is invalid', path: 'spec/fixtures/services/vehicle/loader_file.txt' },
      { locale: :'pt-BR', text: 'o tamanho do arquivo é inválido',
        path: 'spec/fixtures/services/vehicle/loader_file.txt' }
    ] do
      before { stub_const('Vehicle::LoaderFile::LIMIT_FILE_SIZE', 1) }
    end

    it_behaves_like 'many languages', [
      { locale: :en, text: 'file content is not valid', path: 'spec/fixtures/files/lib/file/reader.txt' },
      { locale: :'pt-BR', text: 'o conteúdo do arquivo não é válido', path: 'spec/fixtures/files/lib/file/reader.txt' }
    ]
  end

  context 'when path is valid' do
    it 'returns result with DdtRover' do
      path = 'spec/fixtures/services/vehicle/loader_file.txt'
      expected_dtos = [build(:dto_vehicle), build(:dto_vehicle, :second)]

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
