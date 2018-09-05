class Egreso < ApplicationRecord
  
  default_scope -> { order(fecha: :desc)}
  
  validates :fecha, :descripcion, :emisor, :cantidad, :notas_adicionales, presence: true
  validates_inclusion_of :iva_acreditable_bool, in: [true, false]
  
end
