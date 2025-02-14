class Discount < ApplicationRecord
  validates_presence_of :name,
                        :quantity_threshold,
                        :percentage_discount,
                        :merchant_id
  validates_numericality_of :quantity_threshold,
                            :percentage_discount

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
end
