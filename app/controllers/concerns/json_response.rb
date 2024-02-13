module JsonResponse

  def response_json(message: '', data: {}, status: :ok)
    render json: { status: true, message: message, data: data }, status: status
  end

  def response_json_error(title: '', message: '', code: 0000, status: :bad_request, extra: {})
    render json: { status: false, title: title, message: message }.merge(extra), status: status
  end

end
