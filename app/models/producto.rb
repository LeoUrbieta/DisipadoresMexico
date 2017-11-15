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
    Producto.all.each do |producto|
      
      nombre_columna = producto.columna_relacionada_en_ventas
      
      if(nombre_columna != "") 
        cantidad_restante[nombre_columna] = producto.cantidad_comprada - Venta.all.sum(nombre_columna)
      end
      
    end
    
    return cantidad_restante
    
  end
  
  
end
