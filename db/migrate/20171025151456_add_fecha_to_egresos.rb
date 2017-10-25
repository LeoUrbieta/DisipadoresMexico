class AddFechaToEgresos < ActiveRecord::Migration[5.1]
  def change
    add_column :egresos, :fecha, :date
  end
end
