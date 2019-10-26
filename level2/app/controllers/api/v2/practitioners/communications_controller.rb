class Api::V2::Practitioners::CommunicationsController < ApplicationController
  def create
    communication = Communication.create!(practitioner: practitioner,
                                          sent_at: communication_params[:sent_at])
    render json: communication, status: :created
  end

  private

  def communication_params
    params.require(:communication).permit(:sent_at)
  end

  def practitioner
    Practitioner.find(params[:practitioner_id])
  end
end
