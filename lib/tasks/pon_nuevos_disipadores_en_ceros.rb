Venta.all.each do |venta|
  venta.longitud_125mm = 0
  venta.longitud_75mm_anod = 0
  venta.longitud_87mm_anod = 0
  venta.precio_125mm = 0
  venta.precio_75mm_anod = 0
  venta.precio_87mm_anod = 0
  venta.descuento_125mm = 0
  venta.descuento_75mm_anod = 0
  venta.descuento_87mm_anod = 0
  venta.cortes_125mm = 0
  venta.cortes_75mm_anod = 0
  venta.cortes_87mm_anod = 0
  venta.costo_125mm = 0
  venta.costo_75mm_anod = 0
  venta.costo_87mm_anod = 0
  venta.save
end