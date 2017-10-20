class AddColumnToClientes < ActiveRecord::Migration[5.1]
  def change
    add_column :clientes, :estado, :string
  end
end
