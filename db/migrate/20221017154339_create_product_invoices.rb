class CreateProductInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :product_invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.timestamps
    end
  end
end
