# frozen_string_literal: true

module Vehicle
  class Processor < Callable
    attr_accessor :value, :loader, :trigger, :area, :errors

    ERRORS = {
      error_processing: 'services.processor.error_processing'
    }.freeze

    def initialize(value:, loader: Vehicle::LoaderFile, trigger: Vehicle::Creator, area: Relief::Plateau)
      self.value = value
      self.loader = loader
      self.trigger = trigger
      self.area = area
      self.errors = []

      super
    end

    def call
      response_file = loader.call(path: value)

      return add_error(response_file.error) unless response_file.ok?

      trigger_vehicle(response_file)

      build_response
    rescue StandardError => e
      Tracker::Track.notify(e)

      add_error(ERRORS[:error_processing])
    end

    private

    def add_error(error) = response.error!(error)

    def trigger_vehicle(response_file)
      self.area = build_area(response_file.result.first.dimension)

      response_file.result.each do |dto|
        response_trigge = trigger.call(dto:, area:)
        errors << response_trigge.error unless response_trigge.ok?
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
