# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  get '/authorization-code-grant', to: 'flows#authorization_code_grant'
  get '/clear-session', to: 'flows#clear_session'
  get '/google-code', to: 'google#code'
  get '/google-callback', to: 'google#callback'
  get '/google-jwt', to: 'google#jwt'
  get '/iugu-code', to: 'iugu#code'
  get '/iugu-callback', to: 'iugu#callback'
  get '/iugu-jwt', to: 'iugu#jwt'
  get '/iugu-refresh-token', to: 'iugu#refresh_token'

  get '/iugu-apis', to: 'iugu_apis#index'
  get '/iugu-apis/workspaces', to: 'iugu_apis#get_workspaces'

  get '/shopify-app-install', to: 'shopify#app_install'
  get '/shopify-callback', to: 'shopify#callback'
  get '/shopify-code', to: 'shopify#code'
  get '/shopify-jwt', to: 'shopify#jwt'

  get '/shopify-apis', to: 'shopify_apis#index'
  get '/shopify-apis/orders', to: 'shopify_apis#get_orders'
  get '/shopify-apis/products', to: 'shopify_apis#get_products'
end
