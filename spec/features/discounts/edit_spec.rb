require 'rails_helper'

describe "merchant discount edit page", type: :feature do
  before :each do
    @merchant1 = create(:merchant)

    @discount_1 = @merchant1.discounts.create!(name: "TENoffTEN", percentage_discount: 10, quantity_threshold: 10, merchant_id: @merchant1.id)
    @discount_2 = @merchant1.discounts.create!(name: "TWENTYoffTWENTY", percentage_discount: 20, quantity_threshold: 20, merchant_id: @merchant1.id)
  end

  it "clicking on the edit button on the discount show page redirects to the discount edit page" do
    visit merchant_discount_path(@merchant1, @discount_1)
    click_on "Update Discount"
    expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @discount_1))
  end
  it "the discount edit page has a form with current values pre-loaded" do
    visit edit_merchant_discount_path(@merchant1, @discount_1)

    expect(find_field('Discount Name').value).to eq(@discount_1.name)
    expect(find_field('Percentage Discount').value).to eq(@discount_1.percentage_discount.to_s)
    expect(find_field('Quantity Threshold').value).to eq(@discount_1.quantity_threshold.to_s)

    expect(find_field('Discount Name').value).to_not eq(@discount_2.name)
  end

  it "can fill in form, click submit, and redirect to that discount's show page and see updated info and flash message" do
    visit edit_merchant_discount_path(@merchant1, @discount_1)

    fill_in "Discount Name", with: "SixtyOffInJune"
    fill_in "Percentage Discount", with: 60
    fill_in "Quantity Threshold", with: 15

    click_button "Update Discount"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))
    expect(page).to have_content("Succesfully updated discount info!")
    expect(page).to have_content("SixtyOffInJune")
    expect(page).to have_content("60%")
    expect(page).to have_content("15")
    expect(page).to_not have_content("TENoffTEN")
  end
  it "shows a flash message if not all sections are filled in" do
    visit "/merchant/#{@merchant1.id}/discounts/#{@discount_2.id}/edit"

    fill_in "Discount Name", with: ""
    fill_in "Percentage Discount", with: ""
    fill_in "Quantity Threshold", with: ""

    click_button "Update Discount"

    expect(page).to have_content("All fields must be completed, Percentage Discount and Quantity Threshold must be numbers. Please try again.")
  end
end
