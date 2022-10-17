require 'date'

class ProductsController < ApplicationController
  include Pricer
  def index
    items =
      if params[:month].present?
        month_number = Date::MONTHNAMES.index(params[:month].capitalize)
        month_number_string = "%02d" % month_number
        Item.where("strftime('%m', created_at) = ?", month_number_string)
      else
        Item.all
      end
    @products = items.map { |item| item.price = price(item); item }
  end
end
