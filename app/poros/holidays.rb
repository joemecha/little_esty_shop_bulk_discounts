class Holidays
  attr_reader :next_three_holidays

  def initialize
    holiday_service = HolidayService.new
    @next_three_holidays = @holiday_service.get_holiday_data[0..2]
  end
end
