# frozen_string_literal: true

module Api
  module V1
    module Vehicle
      class RoversController < ApplicationController
        def create
          resp = ::Vehicle::LoaderFile.call(path: path_file)

          return render json: { errors: resp.error }, status: :bad_request unless resp.ok?

          area = build_area(resp.result.first.dimension)

          errors = create_rover(resp.result, area)

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

        def create_rover(result, area)
          errors = []

          result.each do |dto|
            resp = ::Vehicle::RoverCreator.call(dto:, area:)
            errors << resp.error unless resp.ok?
          end

          errors
        end
      end
    end
  end
end
