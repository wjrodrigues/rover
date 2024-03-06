# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Vehicle::RoversController, :controller do
  describe '/api/v1/vehicle/rovers' do
    let(:file) { fixture_file_upload('spec/fixtures/services/vehicle/loader_file.txt') }

    context 'when upload valid file' do
      it 'creates rover' do
        post :create, params: { file: }

        expected = [
          { 'x' => 1, 'y' => 3, 'orientation' => 'N' },
          { 'x' => 5, 'y' => 1, 'orientation' => 'E' }
        ]

        expect(response).to have_http_status(:created)
        expect(expected).to eq(JSON.parse(response.body))
      end
    end

    context 'when upload invalid file' do
      it "returns errors 'file not found'" do
        post :create, params: { file: nil }

        expected = { 'errors' => 'file not found' }

        expect(response).to have_http_status(:bad_request)
        expect(expected).to eq(JSON.parse(response.body))
      end

      it "returns errors 'file content is not valid'" do
        file = fixture_file_upload('spec/fixtures/files/lib/file/reader.txt')

        post :create, params: { file: }

        expected = { 'errors' => 'file content is not valid' }

        expect(response).to have_http_status(:bad_request)
        expect(expected).to eq(JSON.parse(response.body))
      end
    end
  end
end
