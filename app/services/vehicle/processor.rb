# frozen_string_literal: true

module Vehicle
  class Processor < Callable
    attr_accessor :path_file, :loader, :creator, :area

    ERRORS = {
      error_processing: 'services.processor.error_processing'
    }.freeze

    def initialize(path_file:, loader: Vehicle::LoaderFile, creator: Vehicle::Creator, area: Relief::Plateau)
      self.path_file = path_file
      self.loader = loader
      self.creator = creator
      self.area = area

      super
    end

    def call
      response_file = loader.call(path: path_file)

      return add_error(response_file.error) unless response_file.ok?

      errors = create_vehicle(response_file)

      return add_error(errors) unless errors.empty?

      response.result!(area)
    rescue StandardError => e
      Tracker::Track.notify(e)

      add_error(ERRORS[:error_processing])
    end

    private

    def create_vehicle(response_file)
      dimension = response_file.result.first.dimension
      self.area = area.new(width: dimension.width, height: dimension.height)

      errors = []

      response_file.result.each do |dto|
        response_creator = creator.call(dto:, area:)
        errors << response_creator.error unless response_creator.ok?
      end

      errors
    end

    def add_error(error) = response.error!(error)
  end
end
