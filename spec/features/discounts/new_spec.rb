require 'rails_helper'

describe 'Merchant Discount New' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Merchant 1')
    @merchant2 = Merchant.create!(name: 'Merchant 2')
  end

  it 'should be able to fill in a form and create a new discount' do
    visit new_merchant_discount_path(@merchant1)

    fill_in 'Discount Name', with: 'Dingley Doo Birthday'
    fill_in 'Percentage Discount', with: 75
    fill_in 'Quantity Threshold', with: 10

    click_button "Create Discount"

    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_content('Dingley Doo Birthday')
    expect(page).to have_content('Discount has been created!')

  end
  it "displays a message to the user if the new discount was not saved" do
    visit new_merchant_discount_path(@merchant2)

    fill_in 'Discount Name', with: ''
    fill_in 'Percentage Discount', with: ''
    fill_in 'Quantity Threshold', with: ''

    click_button 'Create Discount'

    expect(current_path).to eq(new_merchant_discount_path(@merchant2))
    expect(page).to have_content('Discount was not saved. Try again.')
  end
end
