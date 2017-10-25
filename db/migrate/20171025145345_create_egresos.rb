class CreateEgresos < ActiveRecord::Migration[5.1]
  def change
    create_table :egresos do |t|
      t.text :descripcion
      t.string :emisor
      t.decimal :cantidad
      t.text :notas_adicionales

      t.timestamps
    end
  end
end
