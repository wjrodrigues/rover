# frozen_string_literal: true

module Vehicle
  class Dto
    attr_accessor :dimension, :inital_position, :movement

    DIMENSION = Struct.new(:width, :height)
    INITAL_POSITION = Struct.new(:x_axis, :y_axis, :orientation)
    MOVEMENT = Struct.new(:actions) do
      def left?(value) = value.upcase == 'L'
      def right?(value) = value.upcase == 'R'
      def move?(value) = value.upcase == 'M'
    end

    def initialize(values)
      values.each { |value| kind(value) }
    end

    private

    private_constant :DIMENSION, :INITAL_POSITION

    def clean(value) = value.gsub(Regex::ALL_SPACE, ' ')

    def dimension!(value)
      dimensions = value.split(Regex::ALL_SPACE)
      self.dimension = DIMENSION.new(width: dimensions[0].to_i, height: dimensions[1].to_i)
    end

    def initial_position!(value)
      positions = value.split(Regex::ALL_SPACE)
      self.inital_position = INITAL_POSITION.new(
        x_axis: positions[0].to_i,
        y_axis: positions[1].to_i,
        orientation: positions[2]
      )
    end

    def kind(value)
      value = clean(value)

      case value
      when Regex::DIMENSION
        dimension!(value)
      when Regex::INITIAL_POSITION
        initial_position!(value)
      when Regex::MOVEMENT
        self.movement = MOVEMENT.new(actions: value.chars)
      end
    end
  end
end
