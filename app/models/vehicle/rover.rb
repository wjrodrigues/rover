# frozen_string_literal: true

module Vehicle
  class Rover
    include ActiveModel::Validations

    attr_accessor :x_axis, :y_axis, :path
    private :path=

    validates :x_axis, :y_axis, numericality: { only_integer: true, greater_than: 0 }

    def initialize(x_axis: 0, y_axis: 0)
      [x_axis, y_axis] => Integer, Integer

      self.x_axis = x_axis
      self.y_axis = y_axis
      self.path = []
    end

    def position = { x_axis:, y_axis: }

    def move_x_axis
      self.x_axis = x_axis + 1

      add_path

      self
    end

    def move_y_axis
      self.y_axis = y_axis + 1

      add_path

      self
    end

    private

    def add_path = path << { x_axis:, y_axis: }
  end
end
