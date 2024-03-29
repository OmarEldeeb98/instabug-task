class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]
  before_action :set_application, only: [:index, :create]

  def create
    if Redis.exists?("app##{params[:application_id]}")
      chat_number = Redis.incr("app##{params[:application_id]}")
      Redis.set("chat##{params[:application_id]}##{chat_number}",0)
      ChatCreator.perform_async(chat_number, @application.id)
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

  def index
    data = @application.chats.pluck(:chat_number)
    response_json(message:I18n.t("data_loaded"), data: data, status: :ok)
  end

  private

  def set_chat
    application_id = Application.find_by!(token: params[:application_id]).id
    @chat = Chat.find_by!(application_id: application_id, chat_number: params[:id])
  end

  def set_application
    @application = Application.find_by!(token: params[:application_id])
  end

end
