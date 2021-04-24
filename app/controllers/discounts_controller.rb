class DiscountsController < ApplicationController
  before_action :find_discount_and_merchant, only: [:show, :edit, :update]
  before_action :find_merchant, only: [:new, :create, :index]

  def index
    @discounts = @merchant.discounts
  end

  def show
  end

  def edit
  end

  def update
    @discount.update(discount_params)
    if @discount.save
      flash.notice = "Succesfully updated discount info!"
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash.notice = "All fields must be completed, try again."
      render :edit
    end
  end

  def new
  end

  def create
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:notice] = "Discount has been created!"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:notice] = "Discount was not saved. Try again."
      redirect_to new_merchant_discount_path(@merchant)
    end
  end

  private

  def discount_params
    params.permit(:name, :percentage_discount, :quantity_threshold, :merchant_id)
  end

  def find_discount_and_merchant
    @discount = Discount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_new_id
    Discount.last.id + 1
  end
end
