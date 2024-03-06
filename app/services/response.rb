# frozen_string_literal: true

class Response
  attr_accessor :result, :error

  def initialize(result: nil, error: nil)
    self.result = result
    self.error = error
  end

  def ok? = error.nil?

  def error!(err, extra = {})
    self.error = if I18n.exists?(err)
                   I18n.t(err, **extra)
                 else
                   err
                 end

    self
  end

  def result!(result)
    self.result = result
    self
  end
end
