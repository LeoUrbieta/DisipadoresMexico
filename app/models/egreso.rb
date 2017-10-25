class Egreso < ApplicationRecord
  
  validates :fecha, :descripcion, :emisor, :cantidad, :notas_adicionales, presence: true
  
end
