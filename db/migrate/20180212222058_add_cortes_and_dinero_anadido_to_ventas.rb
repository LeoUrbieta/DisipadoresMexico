class AddCortesAndDineroAnadidoToVentas < ActiveRecord::Migration[5.1]
  def change
    add_column :ventas, :cortes_75mm, :integer
    add_column :ventas, :cortes_87mm, :integer
    add_column :ventas, :cortes_136mm, :integer
    add_column :ventas, :dinero_anadido, :decimal
  end
end
