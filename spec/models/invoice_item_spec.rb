require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one :merchant }
    it { should have_many :discounts }
  end

  before :each do
    @merchant1 = Merchant.create!(name: 'Knows Hair')
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2021-03-27 14:54:09")
  end

  describe "instance methods" do
    it "#add_unit_price_with_discounts - no discount exists" do
      # works if no merchant discount
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 1)
      ii_1.add_unit_price_with_discounts
      expect(ii_1.unit_price).to eq(10)
      expect(ii_1.unit_price_discounts).to eq(null)
    end

    it "#add_unit_price_with_discounts - discount exists" do
      # works if there is a merchant discount
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)

      ii_1.add_unit_price_with_discounts
      expect(ii_1.unit_price).to eq(10)
      expect(ii_1.unit_price_discounts).to eq(8)
    end

    it "greatest_percentage_discount" do
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      expect(ii_1.greatest_percentage_discount).to eq(20)

      discountB = Discount.create!(name: "30off10", percentage_discount: 30, quantity_threshold: 10, merchant_id: @merchant1.id)
      expect(ii_1.greatest_percentage_discount).to eq(30)
    end
  end
end
