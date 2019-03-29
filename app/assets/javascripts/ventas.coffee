# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  sumaTodosCampos()
  llenarCerosEnCampos()
  revisaSiFacturaYMuestra()
  $('.iva_otros').each ->
    nombres = obtenerNombresDeCampos(@)
    actualizaYAnadeIVADeEnviosYOtros('select[name="' + nombres[0] + '"]',$(@),'input[name="' + nombres[1] + '"]','input[name="' + nombres[2] + '"]')
 
  $('.cantidad,.descuento,.comisiones,.iva').on "keydown", (e) ->
    $(@).off().on "input", ->
      if($(@).attr('class').indexOf("cantidad") != -1)
        nombre_producto = extraeNombreProductoDeSelect(@)
        precioPorActualizar = Number($('select[name="precio[' + nombre_producto + ']"]').val())
        actualizaPrecio(@,precioPorActualizar)
      else if($(@).attr('class').indexOf("iva") != -1)
        valor_campo = Number($(@).val())
        nombres = obtenerNombresDeCampos(@)
        actualizaYAnadeIVADeEnviosYOtros('select[name="' + nombres[0] + '"]',$(@),'input[name="' + nombres[1] + '"]','input[name="' + nombres[2] + '"]')
      sumaTodosCampos()

  $('select[name="venta[facturado]"]').change ->
    $('.folio').css('display','none')
    revisaSiFacturaYMuestra()
    
  $('.iva_select').change ->
    iva_por_aplicar = Number($(@).val())
    if($(@).attr("name") == "venta[iva_prod]")
      subtotal = preciosMenosDescuentos()
      $(@).parent().next().children("input").val((subtotal * iva_por_aplicar).toFixed(2))
      total = subtotal + subtotal * iva_por_aplicar
      $('#total_preenvio').val(total.toFixed(2))
    else
      actualizaCamposEnviosYOtros(@)
    sumaTodosCampos()
    
  $('.precio_venta').change ->
    precioDeCampoSelect = Number($(@).val())
    nombre_producto = extraeNombreProductoDeSelect(@) 
    actualizaPrecio($('input[name="venta[' + nombre_producto + ']"]'), precioDeCampoSelect)
    sumaTodosCampos()
    
  $('input').focus ->
    this.select()
    
  $('td.celda_ingresos').click ->
    copyTextToClipboard $(this).html()
    
#Funciones

#Esta función la tomé completamente de stackexchange en esta dirección: https://stackoverflow.com/questions/37478281/select-the-value-of-a-td-on-click-to-ease-copy
copyTextToClipboard = (text) ->
  textArea = document.createElement('textarea')
  
  #Regarding the css: 
  # 1. the element is able to have focus and selection. 
  # 2. if element was to flash render it has minimal visual impact. 
  # 3. less flakyness with selection and copying which might occur if the textarea element is not visible. 
  # The likelihood is the element won't even render, not even a flash, 
  # so some of these are just precautions. However in IE the element 
  # is visible whilst the popup box asking the user for permission for 
  # the web page to copy to the clipboard. 
  
  # Place in top-left corner of screen regardless of scroll position.
  textArea.style.position = 'fixed'
  textArea.style.top = 0
  textArea.style.left = 0
  
  # Ensure it has a small width and height. Setting to 1px / 1em
  # doesn't work as this gives a negative w/h on some browsers.
  textArea.style.width = '2em'
  textArea.style.height = '2em'
  
  # We don't need padding, reducing the size if it does flash render.
  textArea.style.padding = 0
  
  # Clean up any borders.
  textArea.style.border = 'none'
  textArea.style.outline = 'none'
  textArea.style.boxShadow = 'none'
  
  # Avoid flash of white box if rendered for any reason.
  textArea.style.background = 'transparent'
  textArea.value = text
  
  document.body.appendChild textArea
  textArea.select()
  try
    successful = document.execCommand('copy')
    msg = if successful then 'successful' else 'unsuccessful'
    console.log 'Copying text command was ' + msg
  catch err
    console.log 'Oops, unable to copy'
  document.body.removeChild textArea
  return

obtenerNombresDeCampos = (campoReferencia) ->

  nombre_campo_porcentaje_IVA = $(campoReferencia).parents(".row").prev().find("select").attr('name')
  nombre_campo_IVA = $(campoReferencia).parents(".row").prev().children(".campo_iva").children('input').attr('name')
  nombre_campo_a_cambiar = $(campoReferencia).parents(".row").prev().children(".campo_pre_iva").children('input').attr('name')
  
  return [nombre_campo_porcentaje_IVA,nombre_campo_IVA,nombre_campo_a_cambiar]
  

actualizaCamposEnviosYOtros = (campoCambiado) ->
  iva = Number($(campoCambiado).val())
  valor_con_iva = Number($(campoCambiado).parents(".row").next().find("input").val())
  valor_pre_iva = valor_con_iva / (1.0 + iva)
  $(campoCambiado).parent().next().find("input").val((valor_con_iva-valor_pre_iva).toFixed(2))
  $(campoCambiado).parent().prev().find("input").val(valor_pre_iva.toFixed(2))

preciosMenosDescuentos = ->
  suma_precio = 0.0
  suma_descuento = 0.0
  
  $('.subtotal').each ->
    suma_precio = suma_precio + Number($(@).val())
  $('.descuento').each ->
    suma_descuento = suma_descuento + Number($(@).val())
  return suma_precio - suma_descuento
    

extraeNombreProductoDeSelect = (campo_select) ->
  inicio_string = $(campo_select).attr('name').indexOf("longitud")
  if(inicio_string == -1)
    inicio_string = $(campo_select).attr('name').indexOf("cantidad")
  final_string = $(campo_select).attr('name').indexOf("]")
  return $(campo_select).attr('name').slice(inicio_string,final_string)

  
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
  sumaPreciosProductos = sumarCampos '.subtotal','', null,null
  sumarCampos '.descuento','#subtotal', sumaPreciosProductos,'restar'
  actualizaYAnadeIVA('select[name="venta[iva_prod]"]','#subtotal','#iva_productos','#total_preenvio')
  sumarCampos '.totales', '#total_pagado_por_cliente', null, null
  sumarCampos '.comisiones', '#total_post_comisiones', Number($('#total_pagado_por_cliente').val()), 'restar'
  
actualizaYAnadeIVA = (campo_porcentaje_iva,campo_al_que_se_aplica_iva,campo_iva,campo_cambiado)->
  iva = Number($(campo_porcentaje_iva).val()) * Number($(campo_al_que_se_aplica_iva).val())
  $(campo_iva).val(iva.toFixed(2))
  $(campo_cambiado).val((Number($(campo_al_que_se_aplica_iva).val()) + iva).toFixed(2))
  
actualizaYAnadeIVADeEnviosYOtros = (campo_porcentaje_iva,campo_del_que_se_extrae_iva,campo_iva,campo_antes_de_iva) ->
  precio_antes_iva = Number($(campo_del_que_se_extrae_iva).val()) / (1.0 + Number($(campo_porcentaje_iva).val()))
  $(campo_antes_de_iva).val(precio_antes_iva.toFixed(2))
  $(campo_iva).val((Number($(campo_del_que_se_extrae_iva).val()) - precio_antes_iva).toFixed(2))
  
sumarCampos = (campo_cambiado,campos_a_cambiar,otro_campo_a_sumar, operacion) ->
  sum = 0
  $(campo_cambiado).each ->
    sum += Number($(@).val())
  if(operacion == 'restar')
    sum = -sum
  $(campos_a_cambiar).val((otro_campo_a_sumar + sum).toFixed(2))
  return sum