require 'rails_helper'

RSpec.describe 'merchant discount index page' do
  before :each do
    setup
    visit merchant_discounts_path(@merchant1)
  end

  it "displays all of the names and attributes of discounts for this merchant only" do
    expect(page).to have_content("My Bulk Discounts")
    expect(page).to have_content(@discount_1.name)
    expect(page).to have_content(@discount_1.percentage_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)

    expect(page).to have_content(@discount_2.name)
    expect(page).to have_content(@discount_2.percentage_discount)
    expect(page).to have_content(@discount_2.quantity_threshold)

    expect(page).to have_content(@discount_3.name)
    expect(page).to have_content(@discount_3.percentage_discount)
    expect(page).to have_content(@discount_3.quantity_threshold)

    expect(page).to have_content(@discount_4.name)
    expect(page).to have_content(@discount_4.percentage_discount)
    expect(page).to have_content(@discount_4.quantity_threshold)

    expect(page).to_not have_content(@discount_5.name)
    expect(page).to_not have_content(@discount_6.name)
  end

  it "has links to each item's show pages" do
    expect(page).to have_link(@discount_1.name)
    expect(page).to have_link(@discount_2.name)
    expect(page).to have_link(@discount_3.name)
    expect(page).to have_link(@discount_4.name)

    within("#discounts") do
      click_link "#{@discount_1.name}"

      expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts/#{@discount_1.id}")
    end
  end

  it 'has buttons to delete each discount' do
    within("#discount-#{@discount_1.id}") do
      expect(page).to have_button("Delete")
      click_button "Delete"
    end
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to_not have_content(@discount_1.name)
  end

  it 'displays the next three public holidays' do
    within("#upcoming-holidays") do
      expect(page).to have_content("Memorial Day")
      expect(page).to have_content("2021-05-31")
      expect(page).to have_content("Independence Day")
      expect(page).to have_content("2021-07-05")
      expect(page).to have_content("Labor Day")
      expect(page).to have_content("2021-09-06")
    end
  end

  def setup
    Merchant.destroy_all
    Customer.destroy_all
    Discount.destroy_all
    Transaction.destroy_all
    Item.destroy_all
    Invoice.destroy_all
    InvoiceItem.destroy_all

    @merchant1 = Merchant.create!(name: 'Hair Pods')
    @merchant2 = Merchant.create!(name: 'Knows Hair')

    @discount_1 = Discount.create!(name: "TENoffTEN", percentage_discount: 10, quantity_threshold: 10, merchant_id: @merchant1.id)
    @discount_2 = Discount.create!(name: "TWENTYoffTWENTY", percentage_discount: 20, quantity_threshold: 20, merchant_id: @merchant1.id)
    @discount_3 = Discount.create!(name: "THIRTYoffTHIRTY", percentage_discount: 30, quantity_threshold: 30, merchant_id: @merchant1.id)
    @discount_4 = Discount.create!(name: "FORTYoffFORTY", percentage_discount: 40, quantity_threshold: 40, merchant_id: @merchant1.id)

    @discount_5 = Discount.create!(name: "FIFTYoffTEN", percentage_discount: 50, quantity_threshold: 50, merchant_id: @merchant2.id)
    @discount_6 = Discount.create!(name: "SIXTYoffTEN", percentage_discount: 60, quantity_threshold: 60, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 100, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 100, merchant_id: @merchant2.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 100, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 20, unit_price: 100, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_1.id, quantity: 30, unit_price: 100, status: 1)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_2.id, quantity: 40, unit_price: 100, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_1.id, quantity: 50, unit_price: 100, status: 1)

    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_2.id, quantity: 10, unit_price: 100, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_1.id, quantity: 10, unit_price: 100, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_6.id)
  end
end
