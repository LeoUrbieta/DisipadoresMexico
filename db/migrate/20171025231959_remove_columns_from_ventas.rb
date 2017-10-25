class RemoveColumnsFromVentas < ActiveRecord::Migration[5.1]
  def change
    remove_column :ventas, :envio_incluido_en_precio, :boolean
    remove_column :ventas, :envio_a_mi_cargo, :boolean
  end
end
