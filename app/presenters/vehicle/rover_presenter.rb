# frozen_string_literal: true

module Vehicle
  class RoverPresenter
    attr_accessor :vehicle, :errors

    def initialize(vehicle:, errors: nil)
      self.vehicle = vehicle
      self.errors = errors
    end

    def result(format: :hash)
      value = if vehicle.is_a?(Array)
                vehicle.map { |v| build_hash(v) }
              else
                build_hash(vehicle)
              end

      return JSON.pretty_generate(value) if format == :json

      value
    end

    private

    def build_hash(vehicle)
      result = {
        x: vehicle.x_axis,
        y: vehicle.y_axis,
        orientation: vehicle.orientation
      }

      result.merge!(errors:) unless errors.nil?

      result
    end
  end
end
