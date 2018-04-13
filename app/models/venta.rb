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
            :envio_explicito, :dinero_anadido, :subtotal, :total_productos, :total_pagado_por_cliente,
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
                        "total_productos","envio_explicito",
                        "dinero_anadido","total_pagado_por_cliente"]
                           
    nombre_productos.each do |suma_producto|
      suma_producto_actual = BigDecimal.new('0.0')
      ventas.each do |venta|
        suma_producto_actual = (venta.attributes[suma_producto] + suma_producto_actual).round(2)
      end
      
      if suma_producto.include? "longitud"
        suma_producto_actual = (suma_producto_actual/ 100.0).round(2)
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
       precio_unitario_producto = (((suma["precio_"<< producto] - suma["descuento_"<< producto]) / (suma["longitud_"<< producto]))).round(2)
       precio_unitario["precio_unitario_" << producto << "_sin_IVA"] = ["30102306","Disipador de Calor de Alumino de " + producto + " de ancho",suma["longitud_"<< producto],precio_unitario_producto]
       
      elsif (suma["cantidad_"<< producto] != nil  && suma["cantidad_"<< producto] != 0)
        precio_unitario_producto = (((suma["precio_"<< producto] - suma["descuento_"<< producto]) / (suma["cantidad_"<< producto]))).round(2)
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
    precio_unitario["total_pagado_por_cliente"] = ["S/N","Total pagado por el cliente"," - ",suma["total_pagado_por_cliente"]]
    return precio_unitario
    
  end
  
  def self.anadir_envios_y_dinero_anadido_unitarios(suma_conceptos, unitario)
    
    precio_unitario_envio_explicito = (suma_conceptos["envio_explicito"] / 1.16).round(2)
    unitario["precio_unitario_envio_explicito_sin_IVA"] = ["78102203","Envio explicito","1",precio_unitario_envio_explicito]
    
    precio_unitario_servicios_extra = ( suma_conceptos["dinero_anadido"] / 1.16).round(2)
    unitario["precio_unitario_servicios_extra_sin_IVA"] = ["73121601","Servicios extra","1",precio_unitario_servicios_extra]
                                                      
    
  end
  
  def self.dinero_disponible_mercado_libre(ventas)
    
    ventas_mercado_libre = ventas.where("medio_de_venta = :medio_venta",{medio_venta: "MercadoLibre"})
    return ventas_mercado_libre.sum("total_pagado_por_cliente - comisiones - comision_envio")
    
  end
  
  def self.utilidad
    
    nombre_productos = ["longitud_28mm","longitud_50mm","longitud_75mm","longitud_87mm","longitud_100mm","longitud_136mm","longitud_220mm","cantidad_peltier","cantidad_pasta_termica"]
    precio_productos,descuento_productos, costo_productos, utilidad_producto_pre_comision = Array.new(4) { [] }
    utilidad_por_mes_todos_los_productos = Hash.new(0)
    
    
    nombre_productos.each do |producto|
      precio_productos << producto.sub("longitud","precio").sub("cantidad","precio")
      descuento_productos << producto.sub("longitud","descuento").sub("cantidad","descuento")
      costo_productos << producto.sub("longitud","costo").sub("cantidad","costo")
    end
    
    #costo_por_cm = ["0.73","2.03","1.66","2.65","3.11","6.94","7.17","39.59","40.0"]
    
    nombre_productos.each_with_index do |producto,index|
      utilidad_producto_pre_comision << Venta.group_by_month(:fecha, format: "%b %Y").sum("(h01 - h02)-( h03 * h04)".sub("h01",precio_productos[index]).sub("h02",descuento_productos[index]).sub("h03",producto).sub("h04",costo_productos[index]))
    end
    
    utilidad_producto_pre_comision.each {|subhash| subhash.each{|key, value| utilidad_por_mes_todos_los_productos[key] += value}}
    
    envio_explicito = Venta.group_by_month(:fecha, format: "%b %Y").sum("envio_explicito / 1.16")
    dinero_anadido = Venta.group_by_month(:fecha, format: "%b %Y").sum("dinero_anadido / 1.16")
    comisiones_totales = Venta.obtenComisionesDeduciblesYNoDeducibles
    gastos_totales = Venta.obtenGastosTotales
    
    utilidad_por_mes_todos_los_productos.merge!(envio_explicito) { |k, o ,n| (o + n) }.merge!(dinero_anadido) { |k, o ,n| (o + n) }.merge!(gastos_totales){ |k, o ,n| (o - n) }.merge!(comisiones_totales) { |k, o, n| (o - n) }
    
    return utilidad_producto_pre_comision, utilidad_por_mes_todos_los_productos
  end
  
  def self.obtenComisionesDeduciblesYNoDeducibles
    comisiones = Array.new
    comisiones_totales = Hash.new(0)
    
    comisiones << Venta.where(iva_comision_bool: true).group_by_month(:fecha, format: "%b %Y").sum("comisiones / 1.16")
    comisiones << Venta.where(iva_envio_bool: true).group_by_month(:fecha, format: "%b %Y").sum("comision_envio / 1.16")
    comisiones << Venta.where(iva_comision_bool: false).group_by_month(:fecha, format: "%b %Y").sum("comisiones")
    comisiones << Venta.where(iva_envio_bool: false).group_by_month(:fecha, format: "%b %Y").sum("comision_envio")
    
    comisiones.each { |subhash| subhash.each {|prod, value| comisiones_totales[prod] += value}}
    return comisiones_totales
  end
  
  def self.obtenGastosTotales
    egresos = Array.new
    egresos_totales = Hash.new(0)
    
    egresos << Egreso.where(iva_acreditable_bool: true).group_by_month(:fecha, format: "%b %Y").sum("cantidad / 1.16")
    egresos << Egreso.where(iva_acreditable_bool: false).group_by_month(:fecha, format: "%b %Y").sum("cantidad")
    
    egresos.each { |subhash| subhash.each {|prod, value| egresos_totales[prod] += value}}
    return egresos_totales
  end
  
end