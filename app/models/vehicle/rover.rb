# frozen_string_literal: true

module Vehicle
  class Rover
    include ActiveModel::Validations

    attr_accessor :x_axis, :y_axis, :path, :orientation
    private :path=

    NORTH = 'N'
    SOUTH = 'S'
    EAST = 'E'
    WEST = 'W'

    validates :x_axis, :y_axis, numericality: { only_integer: true, greater_than: 0 }

    def initialize(x_axis: 0, y_axis: 0, orientation: NORTH)
      [x_axis, y_axis, orientation] => Integer, Integer, String

      self.x_axis = x_axis
      self.y_axis = y_axis
      self.orientation = orientation
      self.path = []
    end

    def position = { x_axis:, y_axis: }

    def move_left
      return self.orientation = WEST if orientation == NORTH
      return self.orientation = SOUTH if orientation == WEST
      return self.orientation = EAST if orientation == SOUTH

      self.orientation = NORTH if orientation == EAST
    end

    def move_right
      return self.orientation = EAST if orientation == NORTH
      return self.orientation = SOUTH if orientation == EAST
      return self.orientation = WEST if orientation == SOUTH

      self.orientation = NORTH if orientation == WEST
    end

    def move
      move_axis!

      self.x_axis = 0 if x_axis.negative?
      self.y_axis = 0 if y_axis.negative?

      add_path

      self
    end

    private

    def move_axis!
      return self.y_axis += 1 if orientation == NORTH
      return self.y_axis -= 1 if orientation == SOUTH
      return self.x_axis += 1 if orientation == EAST

      self.x_axis -= 1 if orientation == WEST
    end

    def add_path = path << { x_axis:, y_axis:, orientation: }
  end
end
