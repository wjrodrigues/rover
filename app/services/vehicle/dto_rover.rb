# frozen_string_literal: true

module Vehicle
  class DtoRover
    attr_accessor :dimension, :inital_position, :moviments

    DIMENSION = Struct.new(:width, :height)
    INITAL_POSITION = Struct.new(:x_axis, :y_axis, :orientation)

    def initialize(values)
      values.each { |value| kind(value) }
    end

    private

    private_constant :DIMENSION, :INITAL_POSITION

    def clean(value) = value.gsub(Regex::ALL_SPACE, ' ')

    def dimension!(value)
      dimensions = value.split(Regex::ALL_SPACE)
      self.dimension = DIMENSION.new(width: dimensions[0], height: dimensions[1])
    end

    def initial_position!(value)
      positions = value.split(Regex::ALL_SPACE)
      self.inital_position = INITAL_POSITION.new(x_axis: positions[0], y_axis: positions[1], orientation: positions[2])
    end

    def kind(value)
      value = clean(value)

      case value
      when Regex::DIMENSION
        dimension!(value)
      when Regex::INITIAL_POSITION
        initial_position!(value)
      when Regex::MOVEMENT
        self.moviments = value.chars
      end
    end
  end
end
