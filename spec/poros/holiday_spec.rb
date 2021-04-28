require "rails_helper"

RSpec.describe Holiday do
  it "exists" do
    holidays = Holiday.new
    expect(holidays.class).to eq(Holiday)
  end
end
