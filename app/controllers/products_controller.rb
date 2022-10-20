require 'date'

class ProductsController < ApplicationController
  include Purchaser

  skip_before_action :authenticate_customer

  def index
    items =
      if params[:month].present?
        month_number = Date::MONTHNAMES.index(params[:month].capitalize)
        month_number_string = "%02d" % month_number
        Products::Item.where("strftime('%m', created_at) = ?", month_number_string)
      else
        Products::Item.all
      end
    @products = items.map { |item| item.price = compute_price(item, buy: false).price; item }
  end

  def show
    @product = Products::Item.find(params[:id])
    @product.price = compute_price(@product, buy: false).price
    @in_library = Download.where(item: @product, user: current_user).any?
  end
end
