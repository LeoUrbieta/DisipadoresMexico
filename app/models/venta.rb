class Venta < ApplicationRecord
  
  belongs_to :cliente
  validates :cliente_id, presence: true
  
  def self.busca_por_fecha(fecha_inicial, fecha_final)
    Venta.where("fecha >= :start_date AND fecha <= :end_date",{start_date: fecha_inicial, end_date: fecha_final})
  end
  
  def self.suma_productos(ventas)
    total_75mm = BigDecimal.new('0.0')
    ventas.each do |venta|
      total_75mm = venta.precio_75mm + total_75mm
    end
    return total_75mm
  end
  
end