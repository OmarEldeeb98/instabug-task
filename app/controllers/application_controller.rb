class ApplicationController < ActionController::API
  include JsonResponse
  include ErrorResponseActions

  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found
  rescue_from ActionController::RoutingError, :with => :page_not_found
  rescue_from StandardError, :with => :internal_server_error
end
