# frozen_string_literal: true

require "json"
require "date"

# Prices calculator service
class PricesCalculator
  attr_reader :communications, :practitioners

  COMMUNICATION_BASE_PRICE = 0.10
  ADDITIONAL_PAGE_PRICE = 0.07
  COLOR_MODE_PRICE = 0.18
  EXPRESS_DELIVERY_PRICE = 0.60

  def initialize(data)
    @communications = data["communications"]
    @practitioners = data["practitioners"]

    validate!
  end

  def run
    compute_data
  end

  private

  def compute_data
    daily_revenue = communications.each_with_object({}) do |communication, total|
      stringified_date = Date.parse(communication["sent_at"]).strftime('%F')
      if total[stringified_date]
        total[stringified_date] += total_price_for(communication)
      else
        total[stringified_date] = total_price_for(communication)
      end
    end
    format_data(daily_revenue)
  end

  def format_data(data)
    output = data.map do |date, total|
      { "sent_on" => date, "total" => total.round(2) }
    end
    { "totals" => output }
  end

  def find_practitioner(id)
    practitioners.find { |practitioner| practitioner["id"] == id }
  end

  def additional_page_price_for(communication)
    raise ArgumentError, "Attribute pages_number can't be negative" if communication["pages_number"].negative?

    (communication["pages_number"] - 1) * ADDITIONAL_PAGE_PRICE
  end

  def color_mode_price_for(communication)
    communication["color"] ? COLOR_MODE_PRICE : 0
  end

  def express_delivery_price_for(communication)
    practitioner = find_practitioner(communication["practitioner_id"])
    practitioner["express_delivery"] ? EXPRESS_DELIVERY_PRICE : 0
  end

  def total_price_for(communication)
    COMMUNICATION_BASE_PRICE +
      additional_page_price_for(communication) +
      color_mode_price_for(communication) +
      express_delivery_price_for(communication)
  end

  def validate!
    raise ArgumentError, "Wrong input format" if practitioners.nil? || communications.nil?
  end
end

## Example of implementation
data = JSON.parse(File.read("data.json"))

daily_revenue = PricesCalculator.new(data).run

File.open("./output.json", "w") do |f|
  f.write(JSON.pretty_generate(daily_revenue))
end
