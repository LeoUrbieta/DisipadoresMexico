h = Array.new
j = Array.new
iva = BigDecimal('1.16')

nombre_productos = ["longitud_28mm","longitud_50mm","longitud_75mm","longitud_87mm","longitud_100mm","longitud_136mm","longitud_220mm","cantidad_peltier","cantidad_pasta_termica"]

 
precio_productos,descuento_productos = Array.new(2) { [] }

nombre_productos.each do |producto|
  precio_productos << producto.sub("longitud","precio").sub("cantidad","precio")
  descuento_productos << producto.sub("longitud","descuento").sub("cantidad","descuento")
end

Venta.all.each do |venta|
  precio_productos.each do |precio|
    venta[precio] = venta[precio] / iva
    h << venta[precio]
  end
  descuento_productos.each do |descuento|
    venta[descuento] = venta[descuento] / iva
    j << venta[descuento]
  end
  
  venta.subtotal = h.sum - j.sum
  venta.total_productos = venta.subtotal + venta.subtotal * BigDecimal('0.16')
  venta.save
  
end