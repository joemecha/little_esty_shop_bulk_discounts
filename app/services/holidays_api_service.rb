require 'faraday'
require 'json'
require 'pp'

class HolidayService

  # "https://date.nager.at/Api/v2/NextPublicHolidays/US"
  def self.get_us_holidays
    response = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/US")
    json_data = JSON.parse(response.body, symbolize_names: true)
    next_three = []
    next_three << [json_data[0][:name], json_data[0][:date]]
    next_three << [json_data[1][:name], json_data[1][:date]]
    next_three << [json_data[2][:name], json_data[2][:date]]
    next_three
  end
end
