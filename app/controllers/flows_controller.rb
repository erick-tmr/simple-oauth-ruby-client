# frozen_string_literal: true

class FlowsController < ApplicationController
  def authorization_code_grant
    @auth_code_flow = AuthCodeFlow.find(session[:auth_code_flow_id]) if session[:auth_code_flow_id]
  end

  def clear_session
    session.delete(:auth_code_flow_id)

    render :authorization_code_grant
  end
end
