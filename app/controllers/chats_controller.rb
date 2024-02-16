class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]
  before_action :validate_create_chat_params, only: [:create]
  before_action :set_application_id, only: [:create]
  before_action :validate_show_chat_params, only: [:show]

  def create
    if Redis.exists?("app##{params[:application_token]}")
      chat_number = Redis.incr("app##{params[:application_token]}")
      Redis.set("chat##{params[:application_token]}##{chat_number}",0)
      ChatCreator.perform_async(chat_number, @application_id)
      response_json(
        message:I18n.t("chat_created"),
        status: :created,
        data: {
          chat_number: chat_number
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

  def show
    data = ChatSerializer.new(@chat).serializable_hash[:data][:attributes]
    response_json(message:I18n.t("data_loaded"), data: data, status: :ok)
  end

  private

  def set_chat
    application_id = Application.find_by!(token: params[:application_token]).id
    @chat = Chat.find_by!(application_id: application_id, chat_number: params[:chat_number])
  end

  def validate_create_chat_params
    param! :application_token, String, blank: false, required: true
  end

  def validate_show_chat_params
    param! :chat_number, String, blank: false, required: true
    param! :application_token, String, blank: false, required: true
  end

  def set_application_id
    @application_id = Application.find_by!(token: params[:application_token]).id
  end

end
