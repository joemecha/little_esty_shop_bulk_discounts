require 'faraday'
require 'json'
require 'pp'

class HolidayService
  # "https://date.nager.at/Api/v2/NextPublicHolidays/US"
  def self.next_three_holidays
    response = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/US")
    json_data = JSON.parse(response.body, symbolize_names: true)
    next_three = []
    next_three << [json_data[0][:localName], json_data[0][:date]]
    next_three << [json_data[1][:localName], json_data[1][:date]]
    next_three << [json_data[2][:localName], json_data[2][:date]]
    next_three
  end
end
