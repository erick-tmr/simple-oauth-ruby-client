# frozen_string_literal: true

class GoogleController < ApplicationController
  GOOGLE_AUTH_URL = 'https://accounts.google.com/o/oauth2/v2/auth'
  GOOGLE_TOKEN_URL = 'https://oauth2.googleapis.com/token'

  def code
    body = {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      redirect_uri: 'http://localhost:3000/google-callback',
      response_type: 'code',
      scope: 'https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar.events.readonly'
    }

    uri = URI(GOOGLE_AUTH_URL)
    uri.query = URI.encode_www_form(body)

    redirect_to uri.to_s, allow_other_host: true
  end

  def callback
    response = {
      code: params[:code],
      scope: params[:scope]
    }

    redirect_to authorization_code_grant_path(params: response)
  end

  def jwt
    body = {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      code: params[:code],
      redirect_uri: 'http://localhost:3000/google-callback',
      grant_type: 'authorization_code'
    }

    response = Faraday.post(GOOGLE_TOKEN_URL) do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = URI.encode_www_form(body)
    end

    redirect_to authorization_code_grant_path(params: JSON.parse(response.body))
  end
end
