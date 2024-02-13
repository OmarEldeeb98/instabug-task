class ApplicationsController < ApplicationController
  before_action :set_application, only: [:update, :show]
  before_action :validate_application_params, only: [:update, :create]

  def create
    application = Application.new(application_params)
    if application.save
      response_json(
        message:I18n.t("application_created"),
        status: :created,
        data: {
          token: application.token
        }
      )
    else
      response_json_error(
        status: :bad_request,
        title:I18n.t("bad_request"),
        message: I18n.t("creation_failed"),
        extra: {:errors => application.errors}
      )
    end
  end

  def update
    if @application.update(application_params)
      response_json(
        message:I18n.t("application_updated"),
        status: :ok,
        data: {
          token: @application.token
        }
      )
    else
      response_json_error(
        status: :bad_request,
        title:I18n.t("bad_request"),
        message: I18n.t("creation_failed"),
        extra: {:errors => @application.errors}
      )
    end
  end

  def show
    data = ApplicationSerializer.new(@application).serializable_hash[:data][:attributes]
    response_json(message:I18n.t("data_loaded"), data: data, status: :ok)
  end

  private

  def set_application
    @application = Application.find_by(token: params[:token])
    response_json_error(
      status: :not_found,
      title:I18n.t("bad_request"),
      message: I18n.t("record_not_found"),
    ) unless @application
  end

  def validate_application_params
    param! :name, String, blank: false, required: true
  end

  def application_params
    params.permit(:name)
  end
end
