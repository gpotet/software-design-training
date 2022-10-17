class AddTitleAndPriceToProductInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :product_invoices, :price, :float
    add_column :product_invoices, :title, :string
  end
end
