class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :ventas, :envio, :envio_explicito
    rename_column :ventas, :total_envio_incluido_en_precio_mas_total_productos, :envio_agregado_a_precio_productos
    rename_column :ventas, :total_incluyendo_envio, :total_pagado_por_cliente
  end
end
