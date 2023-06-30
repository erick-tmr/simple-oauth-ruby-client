# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  get '/authorization-code-grant', to: 'flows#authorization_code_grant'
  get '/google-code', to: 'google#code'
  get '/google-callback', to: 'google#callback'
  get '/google-jwt', to: 'google#jwt'
  get '/iugu-code', to: 'iugu#code'
  get '/iugu-callback', to: 'iugu#callback'
end
