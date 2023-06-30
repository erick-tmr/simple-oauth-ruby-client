# frozen_string_literal: true

class IuguController < ApplicationController
  IUGU_OAUTH_URL = 'http://identity.iugu.test/authorize'

  def code
    body = {
      client_id: '3P8tpjdNMGRz1UQrfsVhZ7',
      redirect_uri: 'http://localhost:3000/iugu-callback',
      response_type: 'code'
    }

    uri = URI(IUGU_OAUTH_URL)
    uri.query = URI.encode_www_form(body)

    redirect_to uri.to_s, allow_other_host: true
  end

  def callback
    response = {
      code: params[:code]
    }

    redirect_to authorization_code_grant_path(params: response)
  end
end
