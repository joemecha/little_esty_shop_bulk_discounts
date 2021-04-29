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

  # POST-EVAL REFACTOR
  def selected_discount
    discounts.where(merchant_id: item.merchant_id)
             .where("quantity_threshold <= ?", self.quantity)
             .order(percentage_discount: :desc)
             .first
        # Notes: Joins discounts - joined already
        # Notes: try to use MAX - I tried and got: 'TypeError: no implicit conversion of Symbol into Integer'
        #        but :percentage_discount is an integer unsure what I did wrong there
  end

  # METHOD AT EVAL
  # def selected_discount
  #   if discounts.empty? || discounts.where(merchant_id: item.merchant_id)
  #                                   .where("discounts.quantity_threshold <= ?", quantity).empty?
  #     return nil
  #   else
  #     discounts.where(merchant_id: item.merchant_id)
  #       .where("discounts.quantity_threshold <= ?", self.quantity)
  #       .order('discounts.quantity_threshold desc', 'discounts.percentage_discount desc')
  #       .first
  #   end
  # end


  # METHOD AT EVAL - GOAL NOW IS TO ELIMINATE THIS AND ADDED COLUMN AFTER INVOICE MODEL REFACTOR
  def add_unit_price_with_discounts
    if self.selected_discount.nil?
    else
      discount = self.selected_discount.percentage_discount
      self.update(unit_price_discounted: (unit_price * (1.0 - (discount.to_f / 100))))
    end
  end
end
