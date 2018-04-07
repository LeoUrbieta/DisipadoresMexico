class AddIvaToVentas < ActiveRecord::Migration[5.1]
  def change
    add_column :ventas, :iva_prod, :decimal
    add_column :ventas, :iva_envios, :decimal
    add_column :ventas, :iva_anadido, :decimal
    add_column :ventas, :iva_comision_bool, :boolean
    add_column :ventas, :iva_envio_bool, :boolean
  end
end
