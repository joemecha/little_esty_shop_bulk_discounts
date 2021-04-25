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
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2021-03-27 14:54:09")
  end

  # EDIT FOR ii instance methods for calculating discounts
  describe "instance methods" do
    it "#calculate_discounted_price - no discount exists" do
      # works if no merchant discount
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 1)
      expect(ii_1.calculate_discounted_price).to eq(100)
    end

    it "#calculate_discounted_price - discount exists" do
      # works if there is a merchant discount
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      expect(ii_1.calculate_discounted_price).to eq(80)
    end





    xit "greatest_percentage_discount" do
    end

    xit "total_revenue_discounts" do
      # Example 1 - Bulk Discount A is 20% off 10 items - 5 of each item, no discount applied
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_discounts).to eq(100)

      # Example 2 - Bulk Discount A is 20% off 10 items - 10 of one item, 5 of another, discount applied to first item only
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_discounts).to eq(130)

      # Example 3 - Bulk Discount A is 20% off 10 items - Bulk Discount B is 30% off 15 items
      # first item ordered in a quantity of 12, second ordered in a quantity of 15
      # First item discounted at 20%, Second item discounted at 30%
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      discountB = Discount.create!(name: "30off15", percentage_discount: 30, quantity_threshold: 15, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_discounts).to eq((96 + 105)) #201

      # Example 4 - Bulk Discount A is 20% off 10 items - Bulk Discount B is 15% off 15 items
      # first item ordered in a quantity of 12, second ordered in a quantity of 15
      # In this example, Both Item A and Item B should discounted at 20% off. There is no scenario where Bulk Discount B can ever be applied
      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      discountB = Discount.create!(name: "15off15", percentage_discount: 15, quantity_threshold: 15, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_discounts).to eq((96 + 120)) #216

      # Example 5 - Bulk Discount A is 20% off 10 items - Bulk Discount B is 30% off 15 items
      # first item ordered in a quantity of 12, second ordered in a quantity of 15
      # In this example, Both Item A and Item B should discounted at 20% off. There is no scenario where Bulk Discount B can ever be applied
      merchant2 = Merchant.create!(name: 'Hairodynamics')
      item_0 = Item.create!(name: "Olympic Runner Grease", description: "Don't let body hair lose you the gold", unit_price: 20, merchant_id: @merchant2.id)

      ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 1)
      ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_0.id, quantity: 15, unit_price: 10, status: 1)
      discountA = Discount.create!(name: "20off10", percentage_discount: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      discountB = Discount.create!(name: "15off15", percentage_discount: 15, quantity_threshold: 15, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_discounts).to eq((96 + 105 + 150)) #351
    end
  end
end
