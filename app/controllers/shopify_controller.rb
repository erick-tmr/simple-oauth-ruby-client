# frozen_string_literal: true

class ShopifyController < ApplicationController
  SHOPIFY_SHOP = 'quickstart-a1d22ce8'
  CALLBACK_URL = 'http://localhost:3000/shopify-callback'
  REQUESTED_SCOPES = 'read_orders,read_customers'

  def app_install
    @verified = validate_hmac(app_install_params, params[:hmac])
    @params = app_install_params
  end

  def code
    oauth_url = "https://#{SHOPIFY_SHOP}.myshopify.com/admin/oauth/authorize"
    url_params = {
      client_id: ENV['SHOPIFY_CLIENT_ID'],
      scope: REQUESTED_SCOPES,
      redirect_uri: CALLBACK_URL,
      state: 'my-secret'
    }

    uri = URI(oauth_url)
    uri.query = URI.encode_www_form(url_params)

    auth_code_flow = AuthCodeFlow.create(
      issuer: 'shopify',
      auth_code_req_url: uri.to_s,
      requested_scope: REQUESTED_SCOPES,
      client_id: ENV['SHOPIFY_CLIENT_ID']
    )
    session[:auth_code_flow_id] = auth_code_flow.id

    redirect_to uri.to_s, allow_other_host: true
  end

  def callback
    auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])

    auth_code_flow.update(
      code: params[:code]
    )

    redirect_to authorization_code_grant_path(params: { verified: validate_hmac(code_params, params[:hmac]) })
  end

  def jwt
    auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])
    oauth_url = "https://#{SHOPIFY_SHOP}.myshopify.com/admin/oauth/access_token"
    url_params = {
      code: auth_code_flow.code,
      client_id: ENV['SHOPIFY_CLIENT_ID'],
      client_secret: ENV['SHOPIFY_CLIENT_SECRET']
    }
    uri = URI(oauth_url)
    uri.query = URI.encode_www_form(url_params)

    response = Faraday.post(uri.to_s)
    parsed_response = JSON.parse(response.body)

    auth_code_flow.update(
      access_token: parsed_response['access_token'],
      granted_scope: parsed_response['scope'],
      token_req_url: uri.to_s
    )

    redirect_to authorization_code_grant_path
  end

  private

  def app_install_params
    params.permit(:host, :shop, :timestamp)
  end

  def code_params
    params.permit(:code, :host, :shop, :state, :timestamp)
  end

  def validate_hmac(params, hmac)
    sorted_keys = params.keys.sort
    query_string = sorted_keys.map do |key|
      "#{key}=#{params[key]}"
    end.join('&')
    digest = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha256'),
      ENV['SHOPIFY_CLIENT_SECRET'],
      query_string
    )
    ActiveSupport::SecurityUtils.secure_compare(digest, hmac)
  end
end
