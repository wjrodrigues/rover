# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: redirect('/api-docs')

  namespace :api do
    namespace :v1 do
      namespace :vehicle do
        resources :rovers, only: [:create]
      end
    end
  end

  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
end
