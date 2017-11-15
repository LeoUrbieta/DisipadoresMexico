class AddColumnsToProductos < ActiveRecord::Migration[5.1]
  def change
    add_column :productos, :fecha_de_compra, :date
    add_column :productos, :cantidad_comprada, :integer
    add_column :productos, :precio, :decimal
    add_column :productos, :notas_adicionales, :text
    add_column :productos, :perdidas, :integer
  end
end
