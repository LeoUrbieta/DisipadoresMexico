
#Para correr este archivo, usa rails runner lib/tasks/nombre_archivo.rb

productos_con_costo_actual = Producto.where("costo_actual = :costo_boolean",{costo_boolean: true})

Venta.all.each do |venta|
  productos_con_costo_actual.each do |producto|
    venta[producto.columna_relacionada_en_ventas.sub("longitud","costo").sub("cantidad","costo")] = producto.costo_unitario
  end
  venta.save
end