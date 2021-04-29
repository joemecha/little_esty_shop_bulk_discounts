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

# ##### REFACTOR IN PROGRESS  -  INCOMPLETE
  def invoice_discounts
    require "pry"; binding.pry
    invoice_items.joins(:discounts)
                 .having("invoice_items.quantity >= discounts.quantity_threshold")
                 .group("invoice_items.item_id")
                 .select("max(invoice_items.quantity * invoice_items.unit_price * discounts.percentage_discount * 0.01) as discount")
                 .sum("discount")

    # Notes: I wanted to call the .selected_discount method on ii to check (not)nil, but cannot
  end

  # Goal of refactor to reach a point where this works
  def new_total_discount
    total_revenue - invoice_discounts
  end
# #####


#METHOD AT EVAL
  def total_revenue_with_discounts
    populate_discounted_prices # <-- this needs to be cut
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
