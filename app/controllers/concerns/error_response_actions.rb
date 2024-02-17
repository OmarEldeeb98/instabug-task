module ErrorResponseActions
  include JsonResponse

  def resource_not_found
    response_json_error(
      status: :not_found,
      title:I18n.t("bad_request"),
      message: I18n.t("resource_not_found"),
    )
  end

  def page_not_found
    response_json_error(
      status: :not_found,
      title:I18n.t("bad_request"),
      message: I18n.t("page_not_found"),
    )
  end

  def bad_request
    response_json_error(
      status: :bad_request,
      title:I18n.t("bad_request"),
      message: I18n.t("check_params"),
    )
  end
  def internal_server_error
    response_json_error(
      status: 500,
      title:I18n.t("bad_request"),
      message: I18n.t("something_bad_happened"),
    )
  end
end