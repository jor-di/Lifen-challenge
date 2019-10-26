class Api::V2::PractitionerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name
end
