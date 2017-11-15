class AddColumnToProductos < ActiveRecord::Migration[5.1]
  def change
    add_column :productos, :columna_relacionada_en_ventas, :string
  end
end
