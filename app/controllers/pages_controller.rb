class PagesController < ApplicationController
  
  def ingresos
    @claveSAT = Producto.select("nombre_producto, clave_sat").distinct
  end

  def buscar
    
    if( params['fecha_inicial'].empty?)
    
      render 'ingresos'
      
    else
      
      fecha_inicial = params['fecha_inicial'].split('/')
      fecha_final = params['fecha_final'].split('/')
      
      @fecha_inicio = Date::civil(fecha_inicial[2].to_i, fecha_inicial[1].to_i,fecha_inicial[0].to_i)
      @fecha_final = Date::civil(fecha_final[2].to_i, fecha_final[1].to_i, fecha_final[0].to_i)
      
      @claveSAT = Producto.select("nombre_producto,clave_sat").distinct
      @ventas = Venta.busca_productos(@fecha_inicio,@fecha_final,params[:facturado]).order("fecha")
      suma = Venta.suma_productos(@ventas)
      @precios_unitarios = Venta.incluye_precio_unitario(suma)
      @dinero_mercado_libre = Venta.dinero_disponible_mercado_libre(@ventas)
 
      render 'ingresos'
    
    end
    
  end
  
  def estadisticas
    @cantidad_restante = Producto.cantidad_restante()
    @utilidad_por_producto_por_mes, @utilidad_total_por_mes = Venta.utilidad
  end
  
end

