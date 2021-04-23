class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
  end

  def formatted_unit_price
    price = (unit_price.to_f / 100).round(2)
    sprintf("%.2f", price)
  end
end
