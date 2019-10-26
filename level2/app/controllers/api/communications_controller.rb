class Api::CommunicationsController < ApplicationController

  def create
    # This is wrong: we have many practitioners with same first_name&last_name couple in DB.
    # This takes arbitrary the first practitioner of the list.
    # Still, to improve perfomance we can add an index on the DB without the 'unique: true' option.
    # But the request remains wrong. We should find the practitioner through its id (cf API v2).
    practitioner = Practitioner.where(first_name: communication_params[:first_name], last_name: communication_params[:last_name]).first

    communication = Communication.new(practitioner_id: practitioner.id, sent_at: communication_params[:sent_at])

    communication.save!

    render json: communication, status: :created
  end

  def index
    render json: Communication.all.includes(:practitioner), status: :ok
  end

  def communication_params
    params.require(:communication).permit(:first_name, :last_name, :sent_at)
  end

end
