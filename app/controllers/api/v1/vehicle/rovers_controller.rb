# frozen_string_literal: true

module Api
  module V1
    module Vehicle
      class RoversController < ApplicationController
        def create
          response_processor = ::Vehicle::Processor.call(value: path_file)

          if !response_processor.ok? && response_processor.result.nil?
            return render json: { errors: response_processor.error }, status: :bad_request
          end

          presenter = ::Vehicle::Presenter.new(
            vehicle: response_processor.result.vehicles,
            errors: response_processor.error
          )

          render json: presenter.result(format: :json), status: :created
        end

        private

        def path_file
          file = params[:file]

          return file.path if file.is_a?(ActionDispatch::Http::UploadedFile)

          ''
        end
      end
    end
  end
end
