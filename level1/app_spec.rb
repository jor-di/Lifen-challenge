# frozen_string_literal: true

# rspec app_spec.rb

require 'rspec'

require_relative './app.rb'

RSpec.describe PricesCalculator, type: :service do
  let(:data) { JSON.parse(File.read('data.json')) }
  let(:date) { "2019-03-01 00:00:00" }
  let(:basic_data) do
    { "practitioners" =>
        [{
          "id" => 1,
          "first_name" => "Simple",
          "last_name" => "Practitioner",
          "express_delivery" => false
        }],
      "communications" =>
        [{
          "id" => 1,
          "practitioner_id" => 1,
          "pages_number" => 1,
          "color" => false,
          "sent_at" => date
        }] }
  end

  describe "prices" do
    context "for one communication" do
      it "costs 10 cents when no option" do
        daily_revenue = described_class.new(basic_data).run

        expect(daily_revenue["totals"].first["total"])
          .to eq(0.10)
      end

      it "costs 18 cents more when color mode" do
        basic_data["communications"].first["color"] = true

        daily_revenue = described_class.new(basic_data).run

        expect(daily_revenue["totals"].first["total"])
          .to eq(0.10 + 0.18)
      end

      it "costs 7 cents more per additionnal page" do
        basic_data["communications"].first["pages_number"] = 5

        daily_revenue = described_class.new(basic_data).run

        expect(daily_revenue["totals"].first["total"])
          .to eq(0.10 + 4 * 0.07)
      end

      it "cost 60 cents more if the author has the express delivery option" do
        basic_data["practitioners"].first["express_delivery"] = true

        daily_revenue = described_class.new(basic_data).run

        expect(daily_revenue["totals"].first["total"])
          .to eq(0.10 + 0.60)
      end
    end

    context "for many communications" do
      let(:another_communication) do
        {
          "id" => 2,
          "practitioner_id" => 1,
          "pages_number" => 1,
          "color" => false,
          "sent_at" => nil
        }
      end

      it "adds up communications prices when sent on same day" do
        another_communication["sent_at"] = date
        basic_data["communications"] << another_communication

        daily_revenue = described_class.new(basic_data).run

        expect(daily_revenue["totals"].first["total"])
          .to eq(0.10 + 0.10)
      end

      it "divides communications prices when sent on different days" do
        another_date = "2019-03-02 00:00:00"
        another_communication["sent_at"] = another_date
        basic_data["communications"] << another_communication

        daily_revenue = described_class.new(basic_data).run

        expect(daily_revenue["totals"].size).to eq(2)
        expect(daily_revenue["totals"].first["total"])
          .to eq(0.10)
      end
    end
  end

  describe "data format" do
    context "with wrong formatted input data" do
      it "raises an error" do
        wrong_data = { 'foo': 'bar' }

        expect { described_class.new(wrong_data).run }
          .to raise_error(ArgumentError, "Wrong input format")
      end
    end

    it "raises an error if a communication has a negative number of pages" do
      data["communications"].first["pages_number"] = -1

      expect { described_class.new(data).run }
        .to raise_error(ArgumentError, "Attribute pages_number can't be negative")
    end
  end
end
