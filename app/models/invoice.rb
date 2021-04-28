class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  # def total_revenue_discounts
  #   self.total_revenue - (self.total_revenue - self.total_discounted_revenue)
  # end

  def total_discounted_revenue
    require "pry"; binding.pry
    invoice_items.sum('invoice_items.calculate_revenue_with_discounts') # CANT DO THIS
    require "pry"; binding.pry
  end
end
