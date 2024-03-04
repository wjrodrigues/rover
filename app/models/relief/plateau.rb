# frozen_string_literal: true

module Relief
  class Plateau
    include ActiveModel::Validations

    attr_accessor :width, :height

    validates :width, :height, numericality: { only_integer: true, greater_than: 0 }

    def initialize(width:, height:)
      [width, height] => Integer, Integer

      self.width = width
      self.height = height
    end

    def dimension = { width:, height: }

    def to_move?(x_axis:, y_axis:)
      [x_axis, y_axis] => Integer, Integer

      x_axis <= width && y_axis <= height
    end
  end
end
