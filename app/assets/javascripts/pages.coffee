# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'turbolinks:load', ->
  
  $('.datepicker').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
  })
  
  $('.campos_fecha_final').hide()
  
  $('#inicio_datepicker').datepicker().on 'changeDate', ->
    $('.campos_fecha_final').show()
    fecha_inicial = $('#inicio_datepicker').datepicker('getDate')
    $('#final_datepicker').datepicker('update', fecha_inicial)
    $('#final_datepicker').datepicker('setStartDate', fecha_inicial)
  
  $('#cantidad_calculadora,#numero_cortes_calculadora').on 'keypress', (e) ->
    $(@).off().on "input", ->
      calculaPrecioParaProductos()

  $('#tipo_producto').on 'change', (e) ->
    calculaPrecioParaProductos()
    
    
#Funciones

calculaPrecioParaProductos = ->
  lista_precios_producto = precios_calculadora[$('#tipo_producto').val()]
  longitudes = [25,50,75,100,500,1500,3000]
  longitud = Number($('#cantidad_calculadora').val())
  cortes = Number($('#numero_cortes_calculadora').val())
  actualizaPrecioUnitario(lista_precios_producto,longitud,longitudes)
  actualizaPrecioTotal(longitud,cortes)

actualizaPrecioUnitario = (lista_precios,longitud,longitudes) ->
  for long,index in longitudes
    if(longitud < long)
      $('#precio_unitario_calculadora').val(lista_precios[index])
      break
    else
      $('#precio_unitario_calculadora').val(lista_precios[index+1])
      
actualizaPrecioTotal = (longitud, cortes) ->
  p_unit = Number($('#precio_unitario_calculadora').val())
  $('#precio_sin_iva').val((p_unit * longitud + cortes * 0.3 * p_unit).toFixed(2))
  $('#iva').val(Number(($('#precio_sin_iva').val()) * 0.16).toFixed(2))
  $('#precio_neto').val((Number($('#precio_sin_iva').val()) + Number($('#iva').val())).toFixed(2))
  
    
  
  
 

