# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::Vehicle::RoversController', type: :request do
  path '/api/v1/vehicle/rovers' do
    post 'Creates a rover' do
      tags 'Rovers'
      consumes 'application/json'

      response '200', 'rover created' do
        run_test!
      end
    end
  end
end
