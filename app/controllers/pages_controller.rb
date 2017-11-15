class PagesController < ApplicationController
  
  def ingresos
    @ventas = Venta.all.order("fecha")
    
  end

  def buscar
    
    fecha_inicio = Date::civil(params['fecha_inicio(1i)'].to_i, params['fecha_inicio(2i)'].to_i, params['fecha_inicio(3i)'].to_i)
    fecha_final = Date::civil(params['fecha_final(1i)'].to_i, params['fecha_final(2i)'].to_i, params['fecha_final(3i)'].to_i)
    
    @claveSAT = Producto.select("nombre_producto, clave_sat")
    @ventas = Venta.busca_productos(fecha_inicio,fecha_final,params[:facturado]).order("fecha")
    @suma = Venta.suma_productos(@ventas)
    
    render 'ingresos'
    
  end
  
  def estadisticas
    @dinero_disponible = Venta.total_disponible(Venta.all,Egreso.all)
  end
  
  
end
