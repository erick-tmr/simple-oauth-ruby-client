# frozen_string_literal: true

class FlowsController < ApplicationController
  def authorization_code_grant
    @code = params[:code]
    @scope = params[:scope]
    @access_token = params[:access_token]
    @expires_in = params[:expires_in]
    @token_type = params[:token_type]
  end
end
