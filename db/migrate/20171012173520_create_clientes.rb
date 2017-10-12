class CreateClientes < ActiveRecord::Migration[5.1]
  def change
    create_table :clientes do |t|
      t.string :nombre
      t.string :rfc
      t.string :calle
      t.string :numero_exterior
      t.string :numero_interior
      t.string :colonia
      t.string :municipio_delegacion
      t.string :ciudad
      t.string :codigo_postal
      t.string :telefono
      t.string :email
      t.string :persona_contacto
      t.timestamps
    end
  end
end
