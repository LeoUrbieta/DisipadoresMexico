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
      $(@).off().on "input", ->
        if($(@).attr('class').indexOf("cantidad") != -1)
          nombre_producto = extraeNombreProductoDeSelect(@)
          precioPorActualizar = Number($('select[name="precio[' + nombre_producto + ']"]').val())
          actualizaPrecio(@,precioPorActualizar)
        sumaTodosCampos()

  $('select[name="venta[facturado]"]').change ->
    $('.folio').css('display','none')
    revisaSiFacturaYMuestra()
    
  $('.precio_venta').change ->
    precioDeCampoSelect = Number($(@).val())
    nombre_producto = extraeNombreProductoDeSelect(@) 
    actualizaPrecio($('input[name="venta[' + nombre_producto + ']"]'), precioDeCampoSelect)
    sumaTodosCampos()
    
    
#Funciones

extraeNombreProductoDeSelect = (campo_select) ->
  inicio_string = $(campo_select).attr('name').indexOf("longitud")
  if(inicio_string == -1)
    inicio_string = $(campo_select).attr('name').indexOf("cantidad")
  final_string = $(campo_select).attr('name').indexOf("]")
  return $(campo_select).attr('name').slice(inicio_string,final_string)

noEsNumero = (e) ->
  e.which != 8 && e.which != 0 && e.which != 46 && (e.which < 48 || e.which > 57)
  
actualizaPrecio = (campoCambiado, precio) ->
  cantidad_vendida = Number($(campoCambiado).val())
  id_producto = extraeIdProducto(campoCambiado)
  
  precio_total = precio * cantidad_vendida
  
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