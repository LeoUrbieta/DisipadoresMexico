class Cliente < ApplicationRecord
  has_many :ventas
  
  validates :nombre, presence: true
  
  default_scope -> { order(id: :desc)}
  
  def self.busca_cliente(nombre_cliente)
    if(nombre_cliente == "")
      return nil
    else
      return Cliente.where('nombre LIKE ?', '%' + nombre_cliente + '%').all
    end
  end
  
  
end
