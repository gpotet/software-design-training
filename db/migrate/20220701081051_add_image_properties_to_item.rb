class AddImagePropertiesToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :width, :integer
    add_column :items, :height, :integer
    add_column :items, :source, :string
    add_column :items, :format, :string
  end
end
