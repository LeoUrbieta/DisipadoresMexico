# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  sumaTodosCampos()
  llenarCerosEnCampos()
  
  $('.subtotal,.envios,.comisiones').change ->
    sumaTodosCampos()

    
#Funciones    

llenarCerosEnCampos = ->
  $(':input').each ->
    if ( $(@).attr('name') == 'venta[cliente_id]' && $(@).val() == '' )
      $(@).val('')
    else if ($(@).attr('name') == 'venta[folio_factura]')
      $(@).val('S/F')
    else if ($(@).attr('name') == 'venta[notas_adicionales]')
      $(@).val('S/N')
    else if( $(@).val() == '')
      $(@).val('0')
     
    
sumaTodosCampos = ->
  sumarCampos '.subtotal','#subtotal,#total_preenvio', null, null
  sumarCampos '.envios', '#total_pagado_por_cliente', Number($('#total_preenvio').val()), null
  sumarCampos '.comisiones', '#total_post_comisiones', Number($('#total_pagado_por_cliente').val()), 'restar'
  
sumarCampos = (campo_cambiado,campos_a_cambiar,otro_campo_a_sumar, operacion) ->
  sum = 0
  $(campo_cambiado).each ->
    sum += Number($(@).val())
  if(operacion == 'restar')
    sum = -sum
  $(campos_a_cambiar).val((otro_campo_a_sumar + sum).toFixed(2))