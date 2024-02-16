class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update]
  before_action :validate_message_params, only: [:create, :update, :search]
  before_action :set_chat_id, only: [:create, :search]

  def create
    if Redis.exists?("chat##{params[:application_id]}##{params[:chat_id]}")
      message_number = Redis.incr("chat##{params[:application_id]}##{params[:chat_id]}")
      MessageCreator.perform_async(message_params.merge({message_number: message_number, chat_id: @chat_id}).to_h)
      response_json(
        message:I18n.t("chat_created"),
        status: :created,
        data: {
          message_number: message_number
        }
      )
    else
      response_json_error(
        status: :not_found,
        title:I18n.t("bad_request"),
        message: I18n.t("record_not_found")
      )
    end
  end

  def update
    if @message.update(message_params)
      response_json(
        message:I18n.t("message_updated"),
        status: :ok
      )
    else
      response_json_error(
        status: :bad_request,
        title:I18n.t("bad_request"),
        message: I18n.t("updating_failed"),
        extra: {:errors => @message.errors}
      )
    end
  end

  def show
    data = MessageSerializer.new(@message).serializable_hash[:data][:attributes]
    response_json(message:I18n.t("data_loaded"), data: data, status: :ok)
  end

  def search
    result = Message.search(params[:body], @chat_id)
    response_json(message:I18n.t("data_loaded"), data: result, status: :ok)
  end

  private

  def set_message
    application_id = Application.find_by!(token: params[:application_id]).id
    chat_id = Chat.find_by!(application_id: application_id, chat_number: params[:chat_id]).id
    @message = Message.find_by!(chat_id: chat_id, message_number: params[:id])
  end

  def message_params
    params.permit(:body)
  end

  def validate_message_params
    param! :body, String, blank: false, required: true
  end

  def set_chat_id
    application_id = Application.find_by!(token: params[:application_id]).id
    @chat_id = Chat.find_by!(application_id: application_id, chat_number: params[:chat_id]).id
  end

end
