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

  def self.distinct_invoices
    distinct
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_with_discounts
    populate_discounted_prices
    normal = invoice_items.where(invoice_items: {unit_price_discounted: nil})
                          .sum("unit_price * quantity")

    discounted = invoice_items.where.not(invoice_items: {unit_price_discounted: nil})
                              .sum("unit_price_discounted * quantity")

    total = normal + discounted
  end

  def populate_discounted_prices
    invoice_items.each do |ii|
      ii.add_unit_price_with_discounts
    end
  end
end
