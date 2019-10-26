class Api::V2::CommunicationsController < ApplicationController
  def index
    render json: Communication.all.includes(:practitioner),
           each_serializer: ::Api::V2::CommunicationSerializer,
           status: :ok
  end
end
