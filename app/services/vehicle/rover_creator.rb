# frozen_string_literal: true

module Vehicle
  class RoverCreator < Callable
    attr_accessor :dto, :vehicle, :area

    ERRORS = {
      invalid_values: 'values are invalid',
      invalid_location: 'invalid location',
      collision: 'collision route'
    }.freeze

    def initialize(dto:, area:, vehicle: Vehicle::Rover)
      self.dto = dto
      self.vehicle = vehicle
      self.area = area

      super
    end

    def call
      return add_error(:invalid_values) if dto_invalid?

      instance_vehicle!

      return add_error(:invalid_location) if invalid_location?
      return add_error(:collision) if collision?

      explore!(vehicle)
      area.add_vehicle!(vehicle)

      response.result!(vehicle:, area:)
    end

    private

    def add_error(key) = response.error!(ERRORS[key])

    def dto_invalid? = dto.dimension.nil? || dto.inital_position.nil? || dto.movement.nil?

    def instance_vehicle!
      self.vehicle = vehicle.new(
        x_axis: dto.inital_position.x_axis,
        y_axis: dto.inital_position.y_axis,
        orientation: dto.inital_position.orientation
      )
    end

    def invalid_location?(vehicle: self.vehicle) = !area.to_move?(x_axis: vehicle.x_axis, y_axis: vehicle.y_axis)

    def move_left(vehicle, action)
      vehicle.move_left && true if dto.movement.left?(action)
    end

    def move_right(vehicle, action)
      vehicle.move_right && true if dto.movement.right?(action)
    end

    def move(vehicle, action)
      vehicle.move && true if dto.movement.move?(action)
    end

    def explore!(vehicle, collision: false)
      dto.movement.actions.each do |action|
        next if move_left(vehicle, action)
        next if move_right(vehicle, action)

        move(vehicle, action)

        return false if collision && invalid_location?(vehicle:)
      end

      true
    end

    def collision?
      return false if area.vehicles.empty?

      return false if explore!(vehicle.clone, collision: true)

      true
    end
  end
end
