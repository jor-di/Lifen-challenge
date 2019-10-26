class Practitioner < ApplicationRecord
  has_many :communications

  def as_json(options= nil)
    {
      id: id,
      first_name: first_name,
      last_name: last_name
    }
  end
end
