# frozen_string_literal: true

require 'rails_helper'

describe Api::V2::CommunicationsController, type: :controller do
  let(:practitioner) { Practitioner.create! }

  describe "GET /communications" do
    it "renders communications and status with success" do
      communication = Communication.create!(practitioner: practitioner)
      serialized_communication = ::Api::V2::CommunicationSerializer.new(communication)

      get :index

      expect(response.body).to eq([serialized_communication].to_json)
      expect(response).to have_http_status(:success)
    end
  end
end
