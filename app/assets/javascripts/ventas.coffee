# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  sumaTodosCampos()
  llenarCerosEnCampos()
  revisaSiFacturaYMuestra()
 
  $('.cantidad,.descuento,.comisiones,.anadido').on "keypress", (e) ->
    if (noEsNumero(e))
      false
    else
      $(@).on "input", ->
        if($(@).attr('class').indexOf("cantidad") != -1)
          actualizaPrecio(@)
        sumaTodosCampos()

  $('select[name="venta[facturado]"]').change ->
    $('.folio').css('display','none')
    revisaSiFacturaYMuestra()
      
  $('select[name="venta[medio_de_venta]"]').change ->
    $('.cantidad').each ->
      actualizaPrecio(@)
    sumaTodosCampos()
    
#Funciones

noEsNumero = (e) ->
  e.which != 8 && e.which != 0 && e.which != 46 && (e.which < 48 || e.which > 57)
  
actualizaPrecio = (campoCambiado) ->
  cantidad_vendida = Number($(campoCambiado).val())
  id_producto = extraeIdProducto(campoCambiado)
  
  if($('select[name="venta[medio_de_venta]"]').val() == 'MercadoLibre')
    precio_total = Number($('#'+id_producto+'_precio_unitario_ML').text()) * cantidad_vendida
  else
    precio_total = Number($('#'+id_producto+'_precio_unitario').text()) * cantidad_vendida
  
  nombre_producto = id_producto.slice((id_producto.indexOf("_") + 1))
  $('input[name="venta[precio_' + nombre_producto + ']"]').val(precio_total.toFixed(2))

extraeIdProducto = (campo) ->
  inicio_string = $(campo).attr('name').indexOf("[")
  final_string = $(campo).attr('name').indexOf("]")
  return $(campo).attr('name').slice(inicio_string + 1,final_string)
  

revisaSiFacturaYMuestra = ->
  if( $('select[name="venta[facturado]"]').val() == 'true')
      $('.folio').css('display','block')

llenarCerosEnCampos = ->
  $('.zero_init').each ->
    if ($(@).attr('name') == 'venta[folio_factura]' && $(@).val() == '')
      $(@).val('S/F')
    else if ($(@).attr('name') == 'venta[notas_adicionales]' && $(@).val() == '')
      $(@).val('S/N')
    else if( $(@).val() == '')
      $(@).val('0')
     
    
sumaTodosCampos = ->
  sumarCampos '.subtotal','#subtotal', null, null
  sumarCampos '.descuento','#total_preenvio', Number($('#subtotal').val()), 'restar'
  sumarCampos '.anadido', '#total_pagado_por_cliente', Number($('#total_preenvio').val()), null
  sumarCampos '.comisiones', '#total_post_comisiones', Number($('#total_pagado_por_cliente').val()), 'restar'
  
sumarCampos = (campo_cambiado,campos_a_cambiar,otro_campo_a_sumar, operacion) ->
  sum = 0
  $(campo_cambiado).each ->
    sum += Number($(@).val())
  if(operacion == 'restar')
    sum = -sum
  $(campos_a_cambiar).val((otro_campo_a_sumar + sum).toFixed(2))