class Producto < ApplicationRecord
  
  def self.buscar_indices(nombre_columnas)
    
    lista_nombres = Array.new
    
    nombre_columnas.each_index.select{|i| nombre_columnas[i].include?("longitud") || nombre_columnas[i].include?("cantidad")}.each do |indice|
      lista_nombres << nombre_columnas[indice]
    end
    
    return lista_nombres
                                      
  end
  
  
end
