class RemoveEnviosYDevolucionFromVentas < ActiveRecord::Migration[5.1]
  def change
    remove_column :ventas, :envio_agregado_a_precio_productos, :decimal
    remove_column :ventas, :devolucion, :decimal
  end
end
