# frozen_string_literal: true

class IuguApisController < ApplicationController
  IUGU_WORKSPACES_URL = 'https://api.console.iugu.com'

  def index
    @auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])
  end

  def get_workspaces
    auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id])
    conn = Faraday.new(IUGU_WORKSPACES_URL, ssl: { verify: false }) do |f|
      f.request :authorization, 'Bearer', auth_code_flow.access_token
    end

    response = conn.get('/workspaces')
    parsed_response = JSON.parse(response.body)

    @workspace_response = parsed_response

    render :index
  end
end
