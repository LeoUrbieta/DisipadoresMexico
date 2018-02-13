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
    nombre_productos = ["longitud_75mm","precio_75mm", "descuento_75mm",    
                        "longitud_87mm", "precio_87mm","descuento_87mm", 
                        "longitud_136mm", "precio_136mm","descuento_136mm",
                        "cantidad_peltier","precio_peltier","descuento_peltier", 
                        "cantidad_pasta_termica","precio_pasta_termica","descuento_pasta_termica",
                        "total_productos","envio_explicito", "envio_agregado_a_precio_productos",
                        "dinero_anadido","total_pagado_por_cliente"]
    
    nombre_productos.each do |suma_producto|
      suma_producto_actual = BigDecimal.new('0.0')
      ventas.each do |venta|
          suma_producto_actual = venta.attributes[suma_producto] + suma_producto_actual
      end
      suma_productos[suma_producto] = suma_producto_actual
    end
    
    IncluyePrecioUnitario(suma_productos)
    return suma_productos
  end
  
  def self.IncluyePrecioUnitario(suma)
    nombre_producto = ["75mm","87mm","136mm","peltier","pasta_termica"]
    
    nombre_producto.each do |producto|
      if(suma["longitud_"<< producto] != nil && suma["longitud_"<< producto] != 0)
       suma["precio_unitario_" << producto] = (((suma["precio_"<< producto] - suma["descuento_"<< producto]) / (suma["longitud_"<< producto])) / 1.16).round(2)
      elsif (suma["cantidad_"<< producto] != nil  && suma["cantidad_"<< producto] != 0)
        suma["precio_unitario_" << producto] = (((suma["precio_"<< producto] - suma["descuento_"<< producto]) / (suma["cantidad_"<< producto])) / 1.16).round(2)
      else
        suma["precio_unitario_" << producto] = "No hubo ventas de este producto"
      end
      
    end
    
    AnadirEnviosYDineroAnadidoUnitarios(suma)
    
  end
  
  def self.AnadirEnviosYDineroAnadidoUnitarios(suma_conceptos)
    
    suma_conceptos["precio_unitario_envio_explicito"] = (suma_conceptos["envio_explicito"] / 1.16).round(2)
    suma_conceptos["precio_unitario_servicios_extra"] = ((suma_conceptos["envio_agregado_a_precio_productos"] +
                                                          suma_conceptos["dinero_anadido"]) / 1.16).round(2)
    
  end
  
  def self.total_disponible(ventas,egresos)
    
    hash_total_post_comisiones_por_mes = ventas.group_by_month(:fecha, format: "%b").sum("total_post_comisiones")
    hash_egresos_por_mes = egresos.group_by_month(:fecha, format: "%b").sum("cantidad")
    
    return hash_total_post_comisiones_por_mes.merge!(hash_egresos_por_mes) { |k, o, n| o - n }
    
  end
  
  
end