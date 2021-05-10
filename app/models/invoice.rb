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
    whole_discount = invoice_discounts.uniq.sum(&:total_discount)
    (total_revenue - whole_discount).to_f.round(2)
  end

  def invoice_discounts
    invoice_items.joins(:discounts)
                 .where('discounts.quantity_threshold <= invoice_items.quantity')
                 .select('discounts.*, invoice_items.*, (invoice_items.quantity * invoice_items.unit_price * discounts.percentage_discount / 100) AS total_discount')
                 .order('discounts.percentage_discount desc')
  end
end
