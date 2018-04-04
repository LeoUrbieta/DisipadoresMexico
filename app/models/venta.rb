class Venta < ApplicationRecord
  
  belongs_to :cliente
  validates :cliente_id, :longitud_75mm, :longitud_87mm,
            :longitud_28mm, :longitud_50mm, :longitud_100mm, :longitud_220mm,
            :longitud_136mm, :cantidad_peltier, :cantidad_pasta_termica,
            :precio_75mm, :precio_87mm, :precio_136mm, :precio_peltier,
            :precio_28mm, :precio_50mm, :precio_100mm, :precio_220mm,
            :precio_pasta_termica, :descuento_75mm, :descuento_87mm, :descuento_136mm,
            :descuento_28mm, :descuento_50mm, :descuento_100mm, :descuento_220mm,
            :descuento_peltier, :descuento_pasta_termica, 
            :envio_explicito,:envio_agregado_a_precio_productos, 
            :devolucion, :dinero_anadido, :subtotal, :total_productos, :total_pagado_por_cliente,
            :comisiones, :comision_envio, :total_post_comisiones,
            :cortes_75mm, :cortes_87mm, :cortes_136mm, :cortes_28mm, :cortes_50mm,
            :cortes_100mm, :cortes_220mm,
             presence: true, numericality: true
             
  
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
                        "longitud_87mm","precio_87mm","descuento_87mm", 
                        "longitud_136mm","precio_136mm","descuento_136mm",
                        "longitud_28mm","precio_28mm", "descuento_28mm",
                        "longitud_50mm","precio_50mm", "descuento_50mm",
                        "longitud_100mm","precio_100mm", "descuento_100mm",
                        "longitud_220mm","precio_220mm", "descuento_220mm",
                        "cantidad_peltier","precio_peltier","descuento_peltier", 
                        "cantidad_pasta_termica","precio_pasta_termica","descuento_pasta_termica",
                        "total_productos","envio_explicito", "envio_agregado_a_precio_productos",
                        "dinero_anadido","total_pagado_por_cliente"]
                           
    nombre_productos.each do |suma_producto|
      suma_producto_actual = BigDecimal.new('0.0')
      ventas.each do |venta|
        suma_producto_actual = venta.attributes[suma_producto] + suma_producto_actual
      end
      
      if suma_producto.include? "longitud"
        suma_producto_actual = suma_producto_actual/ 100.0
      end
        
      suma_productos[suma_producto] = suma_producto_actual
    end
    
    return suma_productos
  end
  
  def self.incluye_precio_unitario(suma)
    
    precio_unitario = Hash.new
    nombre_producto = ["28mm","50mm","75mm","87mm","100mm","136mm","220mm","peltier","pasta_termica"]
    
    nombre_producto.each do |producto|
      if(suma["longitud_"<< producto] != nil && suma["longitud_"<< producto] != 0)
       precio_unitario_producto = (((suma["precio_"<< producto] - suma["descuento_"<< producto]) / (suma["longitud_"<< producto])) / 1.16).round(2)
       precio_unitario["precio_unitario_" << producto << "_sin_IVA"] = ["30102306","Disipador de Calor de Alumino de " + producto + " de ancho",suma["longitud_"<< producto],precio_unitario_producto]
       
      elsif (suma["cantidad_"<< producto] != nil  && suma["cantidad_"<< producto] != 0)
        precio_unitario_producto = (((suma["precio_"<< producto] - suma["descuento_"<< producto]) / (suma["cantidad_"<< producto])) / 1.16).round(2)
        if producto == "peltier"
          precio_unitario["precio_unitario_" << producto << "_sin_IVA"] = ["60104916",producto.titleize,suma["cantidad_"<< producto],precio_unitario_producto]
        elsif producto == "pasta_termica"
          precio_unitario["precio_unitario_" << producto << "_sin_IVA"] = ["32131008",producto.titleize,suma["cantidad_"<< producto],precio_unitario_producto]
        end
        
      else
        precio_unitario["precio_unitario_" << producto << "_sin_IVA"] = ["S/N",producto.titleize,"0","0"]
      end
      
    end
    
    anadir_envios_y_dinero_anadido_unitarios(suma, precio_unitario)
    return precio_unitario
    
  end
  
  def self.anadir_envios_y_dinero_anadido_unitarios(suma_conceptos, unitario)
    
    precio_unitario_envio_explicito = (suma_conceptos["envio_explicito"] / 1.16).round(2)
    unitario["precio_unitario_envio_explicito_sin_IVA"] = ["78102203","Envio explicito","1",precio_unitario_envio_explicito]
    
    precio_unitario_servicios_extra = ((suma_conceptos["envio_agregado_a_precio_productos"] + suma_conceptos["dinero_anadido"]) / 1.16).round(2)
    unitario["precio_unitario_servicios_extra_sin_IVA"] = ["73121601","Servicios extra","1",precio_unitario_servicios_extra]
                                                      
    
  end
  
  def self.total_disponible(ventas,egresos)
    
    
    hash_total_post_comisiones_por_mes = ventas.group_by_month(:fecha, format: "%b").sum("total_post_comisiones")
    hash_egresos_por_mes = egresos.group_by_month(:fecha, format: "%b").sum("cantidad")
    
    return hash_total_post_comisiones_por_mes.merge!(hash_egresos_por_mes) { |k, o, n| o - n }
    
  end
  
  def self.dinero_disponible_mercado_libre(ventas)
    
    ventas_mercado_libre = ventas.where("medio_de_venta == :medio_venta",{medio_venta: "MercadoLibre"})
    return ventas_mercado_libre.sum("total_pagado_por_cliente - comisiones - comision_envio")
    
  end
  
  
end