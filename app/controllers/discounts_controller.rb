class DiscountsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index, :destroy]
  before_action :find_discount_and_merchant, only: [:show, :edit, :update]

  def index
    @discounts = @merchant.discounts
    @holidays = Holiday.new
  end

  def show
  end

  def edit
  end

  def update
    if @discount.update(discount_params)
      flash.notice = "Succesfully updated discount info!"
      render :show
    else
      flash.notice = "All fields must be completed, Percentage Discount and Quantity Threshold must be numbers. Please try again."
      redirect_to edit_merchant_discount_path(@merchant, @discount)
    end
  end

  def new
    @discount = Discount.new
  end

  def create
    discount = @merchant.discounts.new(discount_params)
    if discount.save
      flash[:notice] = "Discount has been created!"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:notice] = "Discount was not saved. Try again."
      redirect_to new_merchant_discount_path(@merchant)
    end
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:name, :percentage_discount, :quantity_threshold, :merchant_id)
  end

  def find_discount_and_merchant
    @discount = Discount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
