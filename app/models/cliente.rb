class Cliente < ApplicationRecord
  has_many :ventas
  
  validates :nombre, presence: true
  
end
