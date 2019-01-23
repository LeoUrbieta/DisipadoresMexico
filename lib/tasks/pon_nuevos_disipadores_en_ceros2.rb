#Para correr este archivo, usa rails runner lib/tasks/nombre_archivo.rb

Venta.all.each do |venta|
  venta.longitud_230mm = 0
  venta.longitud_75mm_negro = 0
  venta.precio_230mm = 0
  venta.precio_75mm_negro = 0
  venta.descuento_230mm = 0
  venta.descuento_75mm_negro = 0
  venta.cortes_230mm = 0
  venta.cortes_75mm_negro = 0
  venta.costo_230mm = 0
  venta.costo_75mm_negro = 0
  venta.save
end