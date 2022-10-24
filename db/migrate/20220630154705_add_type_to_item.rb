class AddTypeToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :type, :string
  end
end
