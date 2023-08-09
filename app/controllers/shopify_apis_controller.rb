# frozen_string_literal: true

class ShopifyApisController < ApplicationController
  SHOPIFY_SHOP = 'quickstart-a1d22ce8'

  before_action :set_auth_code_flow

  def index; end

  def get_orders
    auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])
    api_url = "https://#{SHOPIFY_SHOP}.myshopify.com/admin/api/2023-07/orders.json"
    url_params = {
      status: 'any'
    }
    headers = {
      'X-Shopify-Access-Token' => auth_code_flow.access_token
    }

    response = Faraday.get(api_url, url_params, headers)
    parsed_response = JSON.parse(response.body)

    @orders_response = parsed_response

    render :index
  end

  def get_products
    auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])
    api_url = "https://#{SHOPIFY_SHOP}.myshopify.com/admin/api/2023-07/products.json"
    url_params = {}
    headers = {
      'X-Shopify-Access-Token' => auth_code_flow.access_token
    }

    response = Faraday.get(api_url, url_params, headers)
    parsed_response = JSON.parse(response.body)

    @products_response = parsed_response

    render :index
  end

  private

  def set_auth_code_flow
    @auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])
  end
end
