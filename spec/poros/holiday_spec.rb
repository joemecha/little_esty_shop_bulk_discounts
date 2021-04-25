require "rails_helper"

RSpec.describe Holiday do
  it "exists" do
    attributes = {
      localName: "Mountain Day",
      date: "2021-07-16"
      }

    holiday = Holiday.new(attributes)

    expect(holiday).to be_a Holiday
    expect(holiday.name).to eq("Mountain Day")
    expect(holiday.date).to eq("2021-07-16")
  end
end
