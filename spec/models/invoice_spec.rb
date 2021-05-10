require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  before :each do
    @merchant1 = Merchant.create!(name: 'Knows Hair')
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2021-03-27 14:54:09")
  end

  describe "class methods" do
    it '.distinct_invoices' do
    end
  end

  describe "instance methods" do
    it "#invoice_discounts" do
      # Example 1 - Bulk Discount A is 20% off 10 items - 5 of each item, no discount applied
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_with_discounts).to eq(100.0)
    end

    it "#invoice_discounts" do
      # Bulk Discount A is 20% off 10 items - 10 of one item, 5 of another, discount applied to first item only
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)

      expect(@invoice_1.invoice_discounts.uniq.sum(&:total_discount)).to eq(20)
    end

    it "#total_revenue_with_discounts" do
      # Example 1 - Bulk Discount A is 20% off 10 items - 5 of each item, no discount applied
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_with_discounts).to eq(100)
    end

    it "#total_revenue_with_discounts" do
      # Example 2 - Bulk Discount A is 20% off 10 items - 10 of one item, 5 of another, discount applied to first item only
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_with_discounts).to eq(80 + 50)
    end

    it "#total_revenue_with_discounts" do
      # Example 3 - Bulk Discount A is 20% off 10 items - Bulk Discount B is 30% off 15 items
        # first item ordered in a quantity of 12, second ordered in a quantity of 15
          # First item discounted at 20%, Second item discounted at 30%
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      discountB = Discount.create!(name: "30off15", percentage_discount: 30, quantity_threshold: 15, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_with_discounts).to eq((96 + 105)) #201
    end

    it "#total_revenue_with_discounts" do
      # Example 4 - Bulk Discount A is 20% off 10 items - Bulk Discount B is 15% off 15 items
        # first item ordered in a quantity of 12, second ordered in a quantity of 15
          # In this example, Both Item A and Item B should discounted at 20% off. There is no scenario where Bulk Discount B can ever be applied
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      discountB = Discount.create!(name: "15off15", percentage_discount: 15, quantity_threshold: 15, merchant_id: @merchant1.id)
      expect(@invoice_1.total_revenue_with_discounts).to eq((96 + 120)) #216
    end

    it "#total_revenue_with_discounts" do
      # Example 5 - Bulk Discount A is 20% off 10 items - Bulk Discount B is 30% off 15 items
        # first item ordered in a quantity of 12, second ordered in a quantity of 15
          # In this example, Both Item A and Item B should discounted at 20% off. There is no scenario where Bulk Discount B can ever be applied
      merchant2 = Merchant.create!(name: 'Hairodynamics')
      item_0 = Item.create!(name: "Olympic Runner Wax", description: "Don't break wind, be the wind", unit_price: 20, merchant_id: merchant2.id)

      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 1)
      ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: item_0.id, quantity: 15, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      discountB = Discount.create!(name: "15off15", percentage_discount: 15, quantity_threshold: 15, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_with_discounts).to eq((96 + 120 + 150)) #366
    end
  end
end
