class AddVideoPropertiesToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :duration, :integer
    add_column :items, :quality, :string
  end
end
