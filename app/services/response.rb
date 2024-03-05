# frozen_string_literal: true

class Response
  attr_accessor :result, :error

  def initialize(result: nil, error: nil)
    self.result = result
    self.error = error
  end

  def ok? = error.nil?

  def error!(err)
    self.error = err
    self
  end

  def result!(result)
    self.result = result
    self
  end
end
