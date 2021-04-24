require 'rails_helper'

RSpec.describe 'merchant discount destroy' do
  before :each do
    Merchant.destroy_all
    Discount.destroy_all
    @merchant1 = create(:merchant)
    @discount_1 = @merchant1.discounts.create!(name: "TENoffTEN", percentage_discount: 10, quantity_threshold: 10, merchant_id: @merchant1.id)
    visit merchant_discounts_path(@merchant1)
  end
  it 'As a merchant, I can delete a discount' do
    within("#discount-#{@discount_1.id}") do
      click_button "Delete"

      expect(current_path).to eq(merchant_discounts_path(@merchant1))
      expect(page).to_not have_content(@discount_1.name)
    end
  end
end
