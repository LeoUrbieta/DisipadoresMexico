class PagesController < ApplicationController
  
  def home
    @ventas = Venta.all
  end

  def buscar
    
    fecha_inicio = Date::civil(params['fecha_inicio(1i)'].to_i, params['fecha_inicio(2i)'].to_i, params['fecha_inicio(3i)'].to_i)
    fecha_final = Date::civil(params['fecha_final(1i)'].to_i, params['fecha_final(2i)'].to_i, params['fecha_final(3i)'].to_i)

    @ventas = Venta.busca_por_fecha(fecha_inicio,fecha_final)
    @suma = Venta.suma_productos(@ventas)
    
    render 'home'
    
  end
end
