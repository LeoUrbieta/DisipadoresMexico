class Venta < ApplicationRecord
  
  belongs_to :cliente
  validates :cliente_id, :longitud_75mm, :longitud_87mm,
            :longitud_136mm, :cantidad_peltier, :cantidad_pasta_termica,
            :precio_75mm, :precio_87mm, :precio_136mm, :precio_peltier,
            :precio_pasta_termica, :envio_explicito,:envio_agregado_a_precio_productos, 
            :devolucion,
             presence: true
  
  def self.busca_productos(fecha_inicial, fecha_final, factura)
    tipo_de_busqueda = "fecha >= :start_date AND fecha <= :end_date"
    facturado_bool = factura == "true"
    
    if(factura == "")
      return Venta.where(tipo_de_busqueda,
      {start_date: fecha_inicial, end_date: fecha_final})
    end
    
    if((factura == "true") || (factura == "false"))
      tipo_de_busqueda << " AND facturado = :facturado_boolean"
      return Venta.where(tipo_de_busqueda,
             {start_date: fecha_inicial, end_date: fecha_final, 
             facturado_boolean: facturado_bool})
    end
    
    Venta.where("fecha >= :start_date AND fecha <= :end_date 
    AND facturado = :facturado_boolean",
    {start_date: fecha_inicial, end_date: fecha_final, 
    facturado_boolean: facturado_bool})
  end
  
  def self.suma_productos(ventas)
    suma_productos = Hash.new
    nombre_productos = ["longitud_75mm","precio_75mm", "longitud_87mm",
    "precio_87mm", "longitud_136mm", "precio_136mm","cantidad_peltier",
    "precio_peltier", "cantidad_pasta_termica" , "precio_pasta_termica", 
    "total_productos","envio_explicito", "envio_agregado_a_precio_productos"]
    
    nombre_productos.each do |suma_producto|
      suma_producto_actual = BigDecimal.new('0.0')
      ventas.each do |venta|
          suma_producto_actual = venta.attributes[suma_producto] + suma_producto_actual
      end
      suma_productos[suma_producto] = suma_producto_actual
    end
    return suma_productos
  end
  
  def self.total_disponible(ventas,egresos)
    
    hash_total_post_comisiones_por_mes = ventas.group_by_month(:fecha, format: "%b").sum("total_post_comisiones")
    hash_egresos_por_mes = egresos.group_by_month(:fecha, format: "%b").sum("cantidad")
    
    return hash_total_post_comisiones_por_mes.merge!(hash_egresos_por_mes) { |k, o, n| o - n }
    
  end
  
  
end