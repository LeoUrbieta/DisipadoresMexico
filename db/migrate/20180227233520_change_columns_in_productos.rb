class ChangeColumnsInProductos < ActiveRecord::Migration[5.1]
  def change
    rename_column :productos, :precio_unitario_mercado_libre, :precio_1
    rename_column :productos, :precio_unitario_shopify, :precio_2
    add_column :productos, :precio_3, :string
    add_column :productos, :precio_4, :string
    add_column :productos, :precio_5, :string
    add_column :productos, :precio_6, :string
    add_column :productos, :precio_7, :string
    add_column :productos, :precio_8, :string
  end
end
