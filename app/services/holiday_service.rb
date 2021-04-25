# require 'faraday'
# require 'json'

class HolidayService
  # "https://date.nager.at/Api/v2/NextPublicHolidays/US"
  def get_holiday_data
    response = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/US")
    json = JSON.parse(response.body, symbolize_names: true)
  end
end
