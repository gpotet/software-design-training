class PurchasesController < ApplicationController
  include Pricer
  def index
    render json: ProductInvoice.where(user_id: params[:user_id])
  end

  def create
    product = Item.find(params[:product_id])
    user = User.find(params[:user_id])
    Download.create(item: product, user: user)
    ProductInvoice.create!(item: product, user: user, title: product.title, price: price(product))
    render json: {}
  end
end
