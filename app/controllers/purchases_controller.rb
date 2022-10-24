class PurchasesController < ApplicationController
  include Purchaser

  def index
    render json: ProductInvoice.where(user: current_user)
  end

  def create
    begin
      @product = Products::Item.find(params[:product_id])

    rescue ActiveRecord::RecordNotFound
      return redirect_to products_path
    end
    compute_price(@product, buy: true)
  end
end
