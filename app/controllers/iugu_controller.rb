# frozen_string_literal: true

class IuguController < ApplicationController
  IUGU_OAUTH_URL = 'https://identity.iugu.test/authorize'
  IUGU_TOKEN_URL = 'https://identity.iugu.test/token'

  def code
    body = {
      client_id: ENV['IUGU_CLIENT_ID'],
      redirect_uri: 'http://localhost:3000/iugu-callback',
      response_type: 'code'
    }

    uri = URI(IUGU_OAUTH_URL)
    uri.query = URI.encode_www_form(body)

    auth_code_flow = AuthCodeFlow.create(
      issuer: 'iugu',
      auth_code_req_url: uri.to_s,
      client_id: ENV['IUGU_CLIENT_ID']
    )
    session[:auth_code_flow_id] = auth_code_flow.id

    redirect_to uri.to_s, allow_other_host: true
  end

  def callback
    auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])

    auth_code_flow.update(
      code: params[:code]
    )

    redirect_to authorization_code_grant_path
  end

  def jwt
    auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])

    body = {
      code: auth_code_flow.code,
      redirect_uri: 'http://localhost:3000/iugu-callback',
      grant_type: 'authorization_code',
      audience: 'Iugu.Platform.ok'
    }

    conn = Faraday.new(IUGU_TOKEN_URL) do |f|
      f.request :authorization, :basic, ENV['IUGU_CLIENT_ID'], ENV['IUGU_CLIENT_SECRET']
      f.request :url_encoded
    end

    response = conn.post('', body)
    parsed_response = JSON.parse(response.body)

    auth_code_flow.update(
      access_token: parsed_response['access_token'],
      id_token: parsed_response['id_token'],
      expires_in: parsed_response['expires_in'],
      token_req_url: response.env.request_body
    )

    redirect_to authorization_code_grant_path
  end
end
