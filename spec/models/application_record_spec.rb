require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do

  describe 'instance methods' do
    it "#formatted_unit_price" do
      item = Item.create(name: "chewing gum", description: "mint", unit_price: 200, status: 1)
      expect(item.formatted_unit_price.to_s).to eq('2.00')
    end

    it "#formatted_date" do
      invoice_1 = Invoice.create(customer_id: 900, status: 1, created_at: 'Mon, 19 Apr 2021 13:50:05 UTC +00:00')
      expect(invoice_1.formatted_date).to eq('Monday, April 19, 2021')
    end
  end
end
