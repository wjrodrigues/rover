# frozen_string_literal: true

module Vehicle
  class RoverPresenter
    attr_accessor :vehicles, :errors

    def initialize(vehicle:, errors: nil)
      self.vehicles = vehicle
      self.errors = errors
    end

    def result(format: :hash)
      value = if array?(vehicles) && !vehicles.empty?
                vehicles.map { |v| build_hash(v) }
              else
                build_hash(vehicles)
              end

      return JSON.pretty_generate(value) if format == :json

      value
    end

    private

    def build_hash(vehicle)
      result = {}

      unless array?(vehicle)
        result.merge!(
          x: vehicle.x_axis,
          y: vehicle.y_axis,
          orientation: vehicle.orientation
        )
      end

      result.merge!(errors:) unless errors.nil? || errors.empty?

      result
    end

    def array?(vehicle) = !vehicle.nil? && vehicle.is_a?(Array)
  end
end
