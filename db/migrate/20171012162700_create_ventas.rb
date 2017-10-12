class CreateVentas < ActiveRecord::Migration[5.1]
  def change
    create_table :ventas do |t|
      t.date :fecha
      t.integer :longitud_75mm
      t.integer :longitud_87mm
      t.integer :longitud_136mm
      t.integer :cantidad_peltier
      t.integer :cantidad_pasta_termica
      t.decimal :precio_75mm
      t.decimal :precio_87mm
      t.decimal :precio_136mm
      t.decimal :precio_peltier
      t.decimal :precio_pasta_termica
      t.decimal :subtotal
      t.decimal :descuento_75mm
      t.decimal :descuento_87mm
      t.decimal :descuento_136mm
      t.decimal :descuento_peltier
      t.decimal :descuento_pasta_termica
      t.decimal :total_productos
      t.decimal :envio
      t.boolean :envio_incluido_en_precio
      t.decimal :total_envio_incluido_en_precio_mas_total_productos
      t.boolean :envio_a_mi_cargo
      t.decimal :total_incluyendo_envio
      t.decimal :comisiones
      t.decimal :comision_envio
      t.decimal :total_post_comisiones
      t.string  :medio_de_venta
      t.boolean :facturado
      t.string  :folio_factura
      t.text    :notas_adicionales
    end
  end
end
