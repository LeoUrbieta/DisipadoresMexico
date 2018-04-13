class AddConceptosToProductos < ActiveRecord::Migration[5.1]
  def change
    add_column :productos, :costo_unitario, :decimal
    add_column :productos, :costo_actual, :boolean
    add_column :ventas, :costo_28mm, :decimal
    add_column :ventas, :costo_50mm, :decimal
    add_column :ventas, :costo_75mm, :decimal
    add_column :ventas, :costo_87mm, :decimal
    add_column :ventas, :costo_100mm, :decimal
    add_column :ventas, :costo_136mm, :decimal
    add_column :ventas, :costo_220mm, :decimal
    add_column :ventas, :costo_peltier, :decimal
    add_column :ventas, :costo_pasta_termica, :decimal
  end
end
