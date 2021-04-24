require 'rails_helper'

describe "merchant discount show page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Knows Hair')

    @discount_1 = Discount.create!(name: "TENoffTEN", percentage_discount: 10, quantity_threshold: 10, merchant_id: @merchant1.id)
    @discount_2 = Discount.create!(name: "TWENTYoffTWENTY", percentage_discount: 20, quantity_threshold: 20, merchant_id: @merchant1.id)
  end

  it "displays all the discount's attributes including name, percentage discount, and quantity threshold" do
    visit merchant_discount_path(@merchant1, @discount_1)

    expect(page).to have_content(@discount_1.name)
    expect(page).to have_content(@discount_1.percentage_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)
    expect(page).to_not have_content(@discount_2.name)

    visit merchant_discount_path(@merchant1, @discount_2)

    expect(page).to have_content(@discount_2.name)
    expect(page).to have_content(@discount_2.percentage_discount)
    expect(page).to have_content(@discount_2.quantity_threshold)
    expect(page).to_not have_content(@discount_3.name)
  end

  # it "has a link to update discount info" do
  #   visit merchant_discount_path(@merchant1, @discount_1)
  #
  #   click_link "Update Discount"
  #
  #   expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts/#{@discount_1.id}/edit")
  # end
end
