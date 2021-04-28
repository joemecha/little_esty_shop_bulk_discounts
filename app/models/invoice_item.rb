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

  def add_unit_price_with_discounts
    if self.greatest_percentage_discount.nil?
    else
      discount = self.greatest_percentage_discount.percentage_discount
      self.update(unit_price_discounted: (unit_price * (1.0 - (discount.to_f / 100))))
    end
  end

  def greatest_percentage_discount
    if discounts.empty? || discounts.where(merchant_id: item.merchant_id)
                                    .where("discounts.quantity_threshold <= ?", quantity).empty?
      return nil
    else
      discounts.where(merchant_id: item.merchant_id)
        .where("discounts.quantity_threshold <= ?", quantity)
        .order('discounts.quantity_threshold desc', 'discounts.percentage_discount desc')
        .first
    end
  end

  # WORKING VERSION BEFORE 'nil' REFACTOR, 20210427 at 1045
  # def greatest_percentage_discount
  #   if discounts.empty?
  #     return 0
  #   else
  #     if discounts.where(merchant_id: item.merchant_id)
  #         .where("discounts.quantity_threshold <= ?", quantity).empty?
  #     else
  #       discounts.where(merchant_id: item.merchant_id)
  #         .where("discounts.quantity_threshold <= ?", quantity)
  #         .order('discounts.quantity_threshold desc', 'discounts.percentage_discount desc')
  #         .first
  #     end
  #   end
  # end
end
