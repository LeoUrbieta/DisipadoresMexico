class CreateProductos < ActiveRecord::Migration[5.1]
  def change
    create_table :productos do |t|
      t.string :nombre_producto
      t.string :clave_sat
      t.string :precio_unitario_mercado_libre
      t.string :precio_unitario_shopify
      t.timestamps
    end
  end
end
