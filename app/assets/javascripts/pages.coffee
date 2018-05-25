# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

longitudes = [25,50,75,100,500,1500,3000]

$(document).on 'turbolinks:load', ->
  
  click_boton_agregar_campos_counter = 0;
  
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
  
  $('.campo_usuario').on 'keypress', (e) ->
    $(@).off().on "input", ->
      calculaPrecioParaProductos($(@))

  $('.lista_productos_calculadora').on 'change', (e) ->
    calculaPrecioParaProductos($(@))
    
  $('#boton_agregar_campos').on 'click', (e) ->
    click_boton_agregar_campos_counter++;
    container = $('#segundo_div')
    html = $('#clone_0').clone(true).appendTo(container)
    findHTMLElementsChangeIds(html, click_boton_agregar_campos_counter)
    if click_boton_agregar_campos_counter == 1
      $('#boton_quitar_campos').css("display","block")
    
  $('#boton_quitar_campos').on 'click', (e) ->
    $('#clone_' + click_boton_agregar_campos_counter)[0].remove()
    click_boton_agregar_campos_counter--;
    if click_boton_agregar_campos_counter == 0
      $('#boton_quitar_campos').css("display","none")
    

  
#Funciones

findHTMLElementsChangeIds = (html_clonado, click_counter) ->
  html_clonado.first()[0].id = 'clone_' +click_counter
  html_clonado.find("select")[0].id = 'tipo_producto_' + click_counter
  html_clonado.find("div #precio_unitario_calculadora_0")[0].id = 'precio_unitario_calculadora_' + click_counter
  html_clonado.find("div #cantidad_calculadora_0")[0].id = 'cantidad_calculadora_' + click_counter
  html_clonado.find("div #numero_cortes_calculadora_0")[0].id = 'numero_cortes_calculadora_' + click_counter
  html_clonado.find("div #precio_sin_iva_0")[0].id = 'precio_sin_iva_' + click_counter
  html_clonado.find("div #iva_0")[0].id = 'iva_' + click_counter
  html_clonado.find("div #precio_neto_0")[0].id = 'precio_neto_' + click_counter
  
calculaPrecioParaProductos = (campo_cambiado) ->
  
  index = campo_cambiado[0].id.lastIndexOf("_")
  numero_de_campo = campo_cambiado[0].id.substr(index + 1)
  lista_precios_producto = precios_calculadora[$('#tipo_producto_' + numero_de_campo).val()]
  longitud = Number($('#cantidad_calculadora_' + numero_de_campo).val())
  cortes = Number($('#numero_cortes_calculadora_' + numero_de_campo).val())
  actualizaPrecioUnitario(lista_precios_producto,longitud, numero_de_campo)
  actualizaPrecioTotal(longitud,cortes, numero_de_campo)

actualizaPrecioUnitario = (lista_precios,longitud, numero_de_campo) ->
  for long,index in longitudes
    if(longitud < long)
      $('#precio_unitario_calculadora_' + numero_de_campo).val(lista_precios[index])
      break
    else
      $('#precio_unitario_calculadora_' + numero_de_campo).val(lista_precios[index+1])
      
actualizaPrecioTotal = (longitud, cortes, numero_de_campo) ->
  p_unit = Number($('#precio_unitario_calculadora_' + numero_de_campo).val())
  $('#precio_sin_iva_' + numero_de_campo).val((p_unit * longitud + cortes * 0.3 * p_unit).toFixed(2))
  $('#iva_' + numero_de_campo).val(Number(($('#precio_sin_iva_' + numero_de_campo).val()) * 0.16).toFixed(2))
  $('#precio_neto_' + numero_de_campo).val((Number($('#precio_sin_iva_' + numero_de_campo).val()) + Number($('#iva_' + numero_de_campo).val())).toFixed(2))
  
    
  
  
 

