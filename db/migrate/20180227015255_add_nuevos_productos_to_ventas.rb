class AddNuevosProductosToVentas < ActiveRecord::Migration[5.1]
  def change
    add_column :ventas, :longitud_28mm, :integer
    add_column :ventas, :longitud_50mm, :integer
    add_column :ventas, :longitud_100mm, :integer
    add_column :ventas, :longitud_220mm, :integer
    add_column :ventas, :precio_28mm, :decimal
    add_column :ventas, :precio_50mm, :decimal
    add_column :ventas, :precio_100mm, :decimal
    add_column :ventas, :precio_220mm, :decimal
    add_column :ventas, :descuento_28mm, :decimal
    add_column :ventas, :descuento_50mm, :decimal
    add_column :ventas, :descuento_100mm, :decimal
    add_column :ventas, :descuento_220mm, :decimal
    add_column :ventas, :cortes_28mm, :integer
    add_column :ventas, :cortes_50mm, :integer
    add_column :ventas, :cortes_100mm, :integer
    add_column :ventas, :cortes_220mm, :integer
  end
end
