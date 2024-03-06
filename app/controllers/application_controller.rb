# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_locale

  private

  def set_locale
    locale = params[:locale]

    I18n.locale = locale.to_sym if locale.present?
  end
end
