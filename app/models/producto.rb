class Producto < ApplicationRecord
  
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
        if(cantidad_restante[nombre_columna] == nil)
          cantidad_restante[nombre_columna] = cantidad_comprada[nombre_columna] - Venta.all.sum(nombre_columna)
        end
      end
    end
  
    return cantidad_restante
    
  end
  
end
