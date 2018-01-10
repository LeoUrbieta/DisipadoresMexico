class Cliente < ApplicationRecord
  has_many :ventas
  
  validates :nombre, presence: true
  
  default_scope -> { order(id: :desc)}
  
end
