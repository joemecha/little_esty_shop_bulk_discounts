class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end





  private

  def discount_params
    params.permit(:percent, :threshold)
  end
end
