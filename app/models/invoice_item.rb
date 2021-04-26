class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def calculate_revenue_with_discounts
    discount = self.greatest_percentage_discount
    if merchant.discounts.empty?
      quantity * unit_price
    else
      quantity * (unit_price * (1 - (discount.to_f / 100)))
    end
  end

  def greatest_percentage_discount
    if discounts.empty?
      return 0
    else
      discounts.where(merchant_id: item.merchant_id)
      .where("discounts.quantity_threshold <= ?", quantity)
      .order('discounts.quantity_threshold desc', 'discounts.percentage_discount desc')
      .first.percentage_discount
    end
  end
end
