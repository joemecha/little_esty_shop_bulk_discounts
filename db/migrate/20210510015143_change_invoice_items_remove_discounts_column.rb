class ChangeInvoiceItemsRemoveDiscountsColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :invoice_items, :unit_price_discounted, :integer
  end
end
