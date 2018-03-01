class Producto < ApplicationRecord
  
  validates :nombre_producto, :precio_1, :precio_2, :precio_3,
            :precio_4, :precio_5, :precio_6, :precio_7, :precio_8,
            :cantidad_comprada, :perdidas,
             presence: true
             
  default_scope -> { order(fecha_de_compra: :asc)}
  
  def self.buscar_indices(nombre_columnas)
    
    lista_nombres = Array.new
    
    nombre_columnas.each_index.select{|i| nombre_columnas[i].include?("longitud") || nombre_columnas[i].include?("cantidad")}.each do |indice|
      lista_nombres << nombre_columnas[indice]
    end
    
    return lista_nombres
                                      
  end
  
  def self.cantidad_restante()
    
    cantidad_restante = Hash.new
    cantidad_comprada = Hash.new
    
    Producto.all.each do |producto|
      
      nombre_columna = producto.columna_relacionada_en_ventas
      
      if(nombre_columna != "")
        cantidad_restante[nombre_columna] = Array.new
        if(cantidad_comprada[nombre_columna] != nil)
          cantidad_comprada[nombre_columna] = cantidad_comprada[nombre_columna] + producto.cantidad_comprada 
        else
          cantidad_comprada[nombre_columna] = producto.cantidad_comprada
        end
      end
    end
    
    Producto.all.each do |producto|
      
      nombre_columna = producto.columna_relacionada_en_ventas
      
      if(nombre_columna != "") 
        if(cantidad_restante[nombre_columna] === [])
          if(nombre_columna.include? "longitud")
            nombre_cortes_producto = Producto.quitaLongitudYPonCortesEnString (nombre_columna)
            longitudPerdidaPorCortes = (Venta.all.sum(nombre_cortes_producto) * 0.3 ).round
            cantidad_restante[nombre_columna] = [cantidad_comprada[nombre_columna], 
                                                Venta.all.sum(nombre_columna), 
                                                longitudPerdidaPorCortes, 
                                                producto.perdidas,
                                                cantidad_comprada[nombre_columna] - 
                                                Venta.all.sum(nombre_columna) - 
                                                longitudPerdidaPorCortes - 
                                                producto.perdidas]
          else
            cantidad_restante[nombre_columna] = [cantidad_comprada[nombre_columna], 
                                                Venta.all.sum(nombre_columna), 
                                                producto.perdidas,
                                                cantidad_comprada[nombre_columna] - 
                                                Venta.all.sum(nombre_columna) - 
                                                producto.perdidas]
          end
        else
          if(nombre_columna.include? "longitud")
          cantidad_restante[nombre_columna] = cantidad_restante[nombre_columna].zip([0,0,0,producto.perdidas,-producto.perdidas]).map { |x,y| x + y }
          else
          cantidad_restante[nombre_columna] = cantidad_restante[nombre_columna].zip([0,0,producto.perdidas,-producto.perdidas]).map { |x,y| x + y }
          end
        end
      end
    end

    return cantidad_restante
    
  end
  
  def self.busca_precios()
    
    precios = Hash.new
    
    Producto.all.each do |producto|
      
      array_precios = Array.new
      array_precios[0] = producto.precio_1
      array_precios[1] = producto.precio_2
      array_precios[2] = producto.precio_3
      array_precios[3] = producto.precio_4
      array_precios[4] = producto.precio_5
      array_precios[5] = producto.precio_6
      array_precios[6] = producto.precio_7
      array_precios[7] = producto.precio_8
      precios[producto.columna_relacionada_en_ventas] = array_precios
    end
    
    return precios
  end
  
  private
  
  def self.quitaLongitudYPonCortesEnString (nombre)
    articulo = nombre[8..-1]
    return "cortes" << articulo
    
  end
  
end
