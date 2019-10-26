class Api::V2::CommunicationSerializer < ActiveModel::Serializer
  attributes :id, :sent_at

  has_one :practitioner
end
