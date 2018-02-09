class PagesController < ApplicationController
  
  def ingresos
    
  end

  def buscar
    
    fecha_inicial = params['fecha_inicial'].split('/')
    fecha_final = params['fecha_final'].split('/')
    
    fecha_inicio = Date::civil(fecha_inicial[2].to_i, fecha_inicial[1].to_i,fecha_inicial[0].to_i)
    fecha_final = Date::civil(fecha_final[2].to_i, fecha_final[1].to_i, fecha_final[0].to_i)
    
    @claveSAT = Producto.select("nombre_producto, clave_sat")
    @ventas = Venta.busca_productos(fecha_inicio,fecha_final,params[:facturado]).order("fecha")
    @suma = Venta.suma_productos(@ventas)
    
    render 'ingresos'
    
  end
  
  def estadisticas
    @dinero_disponible = Venta.total_disponible(Venta.all,Egreso.all)
    @cantidad_restante = Producto.cantidad_restante()
  end
  
end

