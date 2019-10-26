class Communication < ApplicationRecord
  belongs_to :practitioner

  def as_json(options = nil)
    {
      # This rendering is confusing. Practitioner's attributes should be in a nested hash. (cf API v2)
      first_name: practitioner.first_name,
      last_name: practitioner.last_name,
      sent_at: sent_at
    }
  end

end
