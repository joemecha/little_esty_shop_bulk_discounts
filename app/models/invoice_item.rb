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


  def selected_discount
    discounts.where(merchant_id: item.merchant_id)
             .where("quantity_threshold <= ?", self.quantity)
             .order(percentage_discount: :desc)
             .first
  end

  def unit_price_discounted
    unit_price * (selected_discount.percentage_discount.to_f / 100)
  end
end
