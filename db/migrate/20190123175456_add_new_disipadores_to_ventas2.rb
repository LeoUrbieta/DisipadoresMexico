class AddNewDisipadoresToVentas2 < ActiveRecord::Migration[5.1]
  def change
    add_column :ventas, :longitud_230mm, :decimal
    add_column :ventas, :longitud_75mm_negro, :decimal
    add_column :ventas, :precio_230mm, :decimal
    add_column :ventas, :precio_75mm_negro, :decimal
    add_column :ventas, :descuento_230mm, :decimal
    add_column :ventas, :descuento_75mm_negro, :decimal
    add_column :ventas, :cortes_230mm, :decimal
    add_column :ventas, :cortes_75mm_negro, :decimal
    add_column :ventas, :costo_230mm, :decimal
    add_column :ventas, :costo_75mm_negro, :decimal
  end
end
