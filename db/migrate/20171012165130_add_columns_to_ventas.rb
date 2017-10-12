class AddColumnsToVentas < ActiveRecord::Migration[5.1]
  def change
    add_column :ventas, :created_at, :datetime
    add_column :ventas, :updated_at, :datetime
  end
end
