class AddNewDisipadoresToVentas < ActiveRecord::Migration[5.1]
  def change
    add_column :ventas, :longitud_125mm, :decimal
    add_column :ventas, :longitud_75mm_anod, :decimal
    add_column :ventas, :longitud_87mm_anod, :decimal
    add_column :ventas, :precio_125mm, :decimal
    add_column :ventas, :precio_75mm_anod, :decimal
    add_column :ventas, :precio_87mm_anod, :decimal
    add_column :ventas, :descuento_125mm, :decimal
    add_column :ventas, :descuento_75mm_anod, :decimal
    add_column :ventas, :descuento_87mm_anod, :decimal
    add_column :ventas, :cortes_125mm, :decimal
    add_column :ventas, :cortes_75mm_anod, :decimal
    add_column :ventas, :cortes_87mm_anod, :decimal
    add_column :ventas, :costo_125mm, :decimal
    add_column :ventas, :costo_75mm_anod, :decimal
    add_column :ventas, :costo_87mm_anod, :decimal
  end
end
