class ApplicationController < ActionController::Base
  before_action :set_default_response_format
  before_action :authenticate_customer

  attr_reader :current_user

  def set_default_response_format
    request.format = :json unless params[:format]
  end

  def authenticate_customer
    render plain: 'User is not authenticated', status: :unauthorized unless current_user.present?
  end

  def current_user
    @_current_user ||= User.find_by(id: params[:user_id])
  end
end
