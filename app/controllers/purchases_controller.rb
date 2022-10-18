class PurchasesController < ApplicationController
  include Purchaser

  def index
    render json: ProductInvoice.where(user: current_user)
  end

  def create
    begin
      @product = Item.find(params[:product_id])
      already_in_library = Download.where(item: @product, user: current_user).any?
      return render plain: "Product is already in the library of #{current_user.first_name}: #{@product.title}", status: :bad_request if already_in_library
    rescue ActiveRecord::RecordNotFound
      return redirect_to products_path
    end
    Download.create(item: @product, user: current_user)
    invoice = compute_price(@product, buy: true)
    render json: invoice
  end
end
