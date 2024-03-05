# frozen_string_literal: true

module Relief
  class Plateau
    include ActiveModel::Validations

    ERRORS = {
      invalid_location: 'location is not valid',
      not_empty_location: 'location is not empty'
    }.freeze

    attr_accessor :width, :height, :vehicles

    validates :width, :height, numericality: { only_integer: true, greater_than: 0 }

    def initialize(width:, height:)
      [width, height] => Integer, Integer

      self.width = width
      self.height = height
      self.vehicles = []
    end

    def dimension = { width:, height: }

    def to_move?(x_axis:, y_axis:)
      [x_axis, y_axis] => Integer, Integer

      (x_axis <= width && y_axis <= height) && !(x_axis.negative? || y_axis.negative?)
    end

    def add_vehicle!(vehicle)
      x_axis = vehicle.x_axis
      y_axis = vehicle.y_axis

      return nil if vehicles.include?(vehicle)
      return raise ERRORS[:invalid_location] unless to_move?(x_axis:, y_axis:)
      return raise ERRORS[:not_empty_location] unless location_empty?(x_axis:, y_axis:)

      vehicles << vehicle

      true
    end

    private

    private_constant :ERRORS

    def location_empty?(x_axis:, y_axis:) = vehicles.find { |v| v.x_axis == x_axis && v.y_axis == y_axis }.nil?
  end
end
