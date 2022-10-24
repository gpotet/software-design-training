class AddBooksPropertiesToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :isbn, :string
    add_column :items, :purchase_price, :float
    add_column :items, :is_hot, :boolean
  end
end
