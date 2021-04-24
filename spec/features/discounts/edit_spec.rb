require 'rails_helper'

describe "merchant discount edit page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Knows Hair')

    @discount_1 = Discount.create!(name: "TENoffTEN", percentage_discount: 10, quantity_threshold: 10, merchant_id: @merchant1.id)
    @discount_2 = Discount.create!(name: "TWENTYoffTWENTY", percentage_discount: 20, quantity_threshold: 20, merchant_id: @merchant1.id)
  end

  it "sees a form filled in with the discount's attributes" do
    visit edit_merchant_discount_path(@merchant1, @discount_1)

    expect(find_field('Name').value).to eq(@discount_1.name)
    expect(find_field('Percentat Discount').value).to eq(@discount_1.percentage_discount)
    expect(find_field('Quantity Threshold').value).to eq(@discount_1.quantity_threshold.to_s)

    expect(find_field('Name').value).to_not eq(@discount_2.name)
  end

  it "can fill in form, click submit, and redirect to that discount's show page and see updated info and flash message" do
    visit edit_merchant_discount_path(@merchant1, @discount_1)

    fill_in "Name", with: "60OffInJune"
    fill_in "Percentage Discount", with: "60"
    fill_in "Quantity Threshold", with: "15"

    click_button "Submit"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))
    expect(page).to have_content("60OffInJune")
    expect(page).to have_content("60%")
    expect(page).to have_content("15")
    expect(page).to_not have_content("TENoffTEN")
    expect(page).to have_content("Succesfully Updated Discount Info!")
  end
  it "shows a flash message if not all sections are filled in" do
    visit edit_merchant_item_path(@merchant1, @discount_1)

    fill_in "Name", with: ""
    fill_in "Percentage Discount", with: "Eco friendly shampoo"
    fill_in "Quantity Threshold", with: "15"

    click_button "Submit"

    expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @discount_1))
    expect(page).to have_content("All fields must be completed, try again.")
  end
end
