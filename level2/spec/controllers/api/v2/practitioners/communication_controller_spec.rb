# frozen_string_literal: true

require 'rails_helper'

describe Api::V2::Practitioners::CommunicationsController, type: :controller do
  let(:practitioner) { Practitioner.create! }

  describe "POST /communications" do
    it "creates a communication for the specified practitioner and status with success" do
      expect do
        post :create, params: { practitioner_id: practitioner.id, communication: { sent_at: nil } }
      end.to change { practitioner.communications.count }.by(1)

      expect(response).to have_http_status(:success)
    end
  end
end
