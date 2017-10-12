class Venta < ApplicationRecord
  
  belongs_to :cliente
  validates :cliente_id, presence: true
  
end