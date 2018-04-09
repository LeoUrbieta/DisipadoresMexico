class AddIvaAcreditableAEgresos < ActiveRecord::Migration[5.1]
  def change
    add_column :egresos, :iva_acreditable_bool, :boolean
  end
end
