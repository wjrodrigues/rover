# frozen_string_literal: true

module Vehicle
  class Processor < Callable
    attr_accessor :path_file, :loader, :creator, :area, :errors

    ERRORS = {
      error_processing: 'services.processor.error_processing'
    }.freeze

    def initialize(path_file:, loader: Vehicle::LoaderFile, creator: Vehicle::Creator, area: Relief::Plateau)
      self.path_file = path_file
      self.loader = loader
      self.creator = creator
      self.area = area
      self.errors = []

      super
    end

    def call
      response_file = loader.call(path: path_file)

      return add_error(response_file.error) unless response_file.ok?

      create_vehicle(response_file)

      build_response
    rescue StandardError => e
      Tracker::Track.notify(e)

      add_error(ERRORS[:error_processing])
    end

    private

    def add_error(error) = response.error!(error)

    def create_vehicle(response_file)
      self.area = build_area(response_file.result.first.dimension)

      response_file.result.each do |dto|
        response_creator = creator.call(dto:, area:)
        errors << response_creator.error unless response_creator.ok?
      end
    end

    def build_area(dimension) = area.new(width: dimension.width, height: dimension.height)

    def build_response
      response.result!(area) unless area.vehicles.empty?

      add_error(errors) unless errors.empty?

      response
    end
  end
end
