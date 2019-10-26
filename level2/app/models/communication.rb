class Communication < ApplicationRecord
  belongs_to :practitioner

  def as_json(options = nil)
    {
      # This rendering is confusing. Practitioner's attributes should be in a nested hash.
      # It is left as it is here for api versioning purposes: we cannot modify the current output of the endpoint.
      # See API V2 for better implementation.
      first_name: practitioner.first_name,
      last_name: practitioner.last_name,
      sent_at: sent_at
    }
  end

end
