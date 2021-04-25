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

  def greatest_percentage_discount
    # if # discount exists && merchant.discount.count > 1
    # else
      # the only discount
    # end
  end

  def calculate_discounted_price
    # require "pry"; binding.pry
    if merchant.discounts.empty? # greatest_percentage_discount.nil?
      quantity * unit_price
    else
      quantity * (unit_price * (1 - (discounts[0].percentage_discount.to_f / 100)))
    end
  end
end
