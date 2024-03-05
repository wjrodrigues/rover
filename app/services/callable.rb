# frozen_string_literal: true

class Callable
  attr_accessor :response

  private_class_method :new

  def self.call(...)
    new(...).call
  end

  def initialize(...)
    self.response = Response.new
  end

  def assign!(keys, params)
    params.deep_symbolize_keys! if params.is_a?(Hash)

    keys.each { |key| send("#{key}=", params[key]) }
  end
end
