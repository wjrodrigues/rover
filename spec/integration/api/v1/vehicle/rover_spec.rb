# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::Vehicle::RoversController, type: :request do
  path '/api/v1/vehicle/rovers' do
    post 'Creates a rover' do
      tags 'Rovers'
      description 'creates the rover and guides it on the surface'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :locale, in: :query, type: :string, default: :en, require: false
      parameter name: :file,
                in: :formData,
                schema: {
                  type: :object,
                  properties: {
                    file: { type: :file, name: :file, description: 'file with rover information' }
                  },
                  required: %w[file]
                }

      response 201, 'rover created' do
        let(:file) { fixture_file_upload('spec/fixtures/services/vehicle/loader_file.txt') }

        run_test! do |response|
          body = JSON.parse(response.body)
          expected = [
            { 'x' => 1, 'y' => 3, 'orientation' => 'N' },
            { 'x' => 5, 'y' => 1, 'orientation' => 'E' }
          ]

          expect(body).to eq(expected)
        end

        example 'application/json', :success, [
          { 'x' => 1, 'y' => 3, 'orientation' => 'N' },
          { errors: 'error when processing information' }
        ]
      end

      response 400, 'error when processing' do
        let(:file) { '' }

        run_test! do |response|
          body = JSON.parse(response.body)
          expected = { 'errors' => 'file not found' }

          expect(body).to eq(expected)
        end

        example 'application/json', :failed, { errors: 'file not found' }
      end
    end
  end
end
