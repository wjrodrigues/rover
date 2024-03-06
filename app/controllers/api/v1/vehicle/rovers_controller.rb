# frozen_string_literal: true

module Api
  module V1
    module Vehicle
      class RoversController < ApplicationController
        def create
          response_file = ::Vehicle::LoaderFile.call(path: path_file)

          return render json: { errors: response_file.error }, status: :bad_request unless response_file.ok?

          area = build_area(response_file.result.first.dimension)

          errors = create_rover(response_file.result, area)

          presenter = ::Vehicle::RoverPresenter.new(vehicle: area.vehicles, errors:)

          render json: presenter.result(format: :json), status: :created
        end

        private

        def path_file
          file = params[:file]

          return file.path if file.is_a?(ActionDispatch::Http::UploadedFile)

          ''
        end

        def build_area(dimension) = ::Relief::Plateau.new(width: dimension.width, height: dimension.height)

        def create_rover(dtos, area)
          errors = []

          dtos.each do |dto|
            response_creator = ::Vehicle::RoverCreator.call(dto:, area:)
            errors << response_creator.error unless response_creator.ok?
          end

          errors
        end
      end
    end
  end
end
