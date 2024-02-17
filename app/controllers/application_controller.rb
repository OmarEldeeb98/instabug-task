class ApplicationController < ActionController::API
  include JsonResponse
  include ErrorResponseActions

  rescue_from ActionDispatch::Http::Parameters::ParseError, :with => :bad_request
  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found
  rescue_from ActionController::RoutingError, :with => :page_not_found
  rescue_from NameError, :with => :internal_server_error
  rescue_from NoMethodError, :with => :internal_server_error
end
