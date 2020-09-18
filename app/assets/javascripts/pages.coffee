# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

longitudes = [25,50,75,100,500,1500,3000]

click_boton_agregar_campos_counter = 0;

$(document).on 'turbolinks:load', ->

  prellenarEnvioEnCalculadora()

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

  $('.campo_usuario').on 'keydown', (e) ->
    $(@).off().on "input", ->
      calculaPrecioParaProductos($(@))

  $('#envio').on 'keydown', (e) ->
    $(@).off().on "input", ->
      calculaPrecioConEnvio($(@))

  $('.lista_productos_calculadora').on 'change', (e) ->
    calculaPrecioParaProductos($(@))

  $('#boton_agregar_campos').on 'click', (e) ->
    click_boton_agregar_campos_counter++;
    container = $('#segundo_div')
    html = $('#clone_0').clone(true).appendTo(container)
    findHTMLElementsChangeIds(html, click_boton_agregar_campos_counter)
    actualizaPrecioTotal()
    if click_boton_agregar_campos_counter == 1
      $('#boton_quitar_campos').css("display","block")

  $('#boton_quitar_campos').on 'click', (e) ->
    $('#clone_' + click_boton_agregar_campos_counter)[0].remove()
    actualizaPrecioTotal()
    click_boton_agregar_campos_counter--;
    if click_boton_agregar_campos_counter == 0
      $('#boton_quitar_campos').css("display","none")



#Funciones

findHTMLElementsChangeIds = (html_clonado, click_counter) ->
  html_clonado.first()[0].id = 'clone_' +click_counter
  html_clonado.find("select")[0].id = 'tipo_producto_' + click_counter
  html_clonado.find("div #precio_unitario_calculadora_0")[0].id = 'precio_unitario_calculadora_' + click_counter
  html_clonado.find("div #cantidad_calculadora_0")[0].id = 'cantidad_calculadora_' + click_counter
  html_clonado.find("div #numero_piezas_calculadora_0")[0].id = 'numero_piezas_calculadora_' + click_counter
  html_clonado.find("div #longitud_total_calculadora_0")[0].id = 'longitud_total_calculadora_' + click_counter
  html_clonado.find("div #iva_precio_unitario_calculadora_0")[0].id = 'iva_precio_unitario_calculadora_' + click_counter
  html_clonado.find("div #precio_unitario_neto_calculadora_0")[0].id = 'precio_unitario_neto_calculadora_' + click_counter
  html_clonado.find("div #iva_precio_por_pieza_calculadora_0")[0].id = 'iva_precio_por_pieza_calculadora_' + click_counter
  html_clonado.find("div #precio_por_pieza_neto_calculadora_0")[0].id = 'precio_por_pieza_neto_calculadora_' + click_counter
  html_clonado.find("div #precio_por_pieza_0")[0].id = 'precio_por_pieza_' + click_counter
  html_clonado.find("div #precio_sin_iva_0")[0].id = 'precio_sin_iva_' + click_counter
  html_clonado.find("div #iva_renglon_0")[0].id = 'iva_renglon_' + click_counter
  html_clonado.find("div #precio_neto_0")[0].id = 'precio_neto_' + click_counter

calculaPrecioParaProductos = (campo_cambiado) ->

  index = campo_cambiado[0].id.lastIndexOf("_")
  numero_de_campo = campo_cambiado[0].id.substr(index + 1)

  lista_productos_en_calculo = []
  num_renglones = [0..click_boton_agregar_campos_counter]
  for i in num_renglones
    if parseInt(i) != parseInt(numero_de_campo)
      lista_productos_en_calculo.push [$('#tipo_producto_' + i).val(),i]

  lista_precios_producto = precios_calculadora[$('#tipo_producto_' + numero_de_campo).val()]
  producto = $('#tipo_producto_' + numero_de_campo).val()
  longitud_total = Number($('#cantidad_calculadora_' + numero_de_campo).val()) * Number($('#numero_piezas_calculadora_' + numero_de_campo).val())
  piezas = Number($('#numero_piezas_calculadora_' + numero_de_campo).val())
  lista_productos_repetidos = actualizaPrecioUnitario(lista_precios_producto,longitud_total, numero_de_campo,lista_productos_en_calculo,producto,piezas)
  actualizaPrecioRenglon(longitud_total, piezas, numero_de_campo,lista_productos_repetidos)
  actualizaPrecioTotal()

actualizaPrecioUnitario = (lista_precios,longitud, numero_de_campo,lista_productos_en_calculo,producto,piezas) ->

  Number($('#longitud_total_calculadora_' + numero_de_campo).val(longitud + 0.3 * piezas))

  lista_productos_repetidos = []

  suma_longitud_total = longitud

  for producto_renglon in lista_productos_en_calculo
    if producto == producto_renglon[0]
      lista_productos_repetidos.push producto_renglon[1]

  if lista_productos_repetidos.length != 0
    suma_longitud_total_elementos_repetidos = 0
    for numero_de_renglon_de_elemento_repetido in lista_productos_repetidos
      campo_del_cual_tomare_longitud = $('#longitud_total_calculadora_' + numero_de_renglon_de_elemento_repetido)
      suma_longitud_total_elementos_repetidos += Number(campo_del_cual_tomare_longitud.val())

    $('#longitud_total_calculadora_' + numero_de_campo).val((longitud + 0.3 * piezas).toFixed(2))
    suma_longitud_total_elementos_repetidos += Number($('#longitud_total_calculadora_' + numero_de_campo).val())
    suma_longitud_total = suma_longitud_total_elementos_repetidos

  for long,index in longitudes
    if(suma_longitud_total < long)
      $('#precio_unitario_calculadora_' + numero_de_campo).val(lista_precios[index])
      if lista_productos_repetidos.length != 0
        llenaCampoPrecioUnitarioProductoRepetido(numero_de_renglon_de_elemento_repetido,lista_productos_repetidos,lista_precios,index)
      break
    else
      $('#precio_unitario_calculadora_' + numero_de_campo).val(lista_precios[index+1])
      if lista_productos_repetidos.length != 0
        llenaCampoPrecioUnitarioProductoRepetido(numero_de_renglon_de_elemento_repetido,lista_productos_repetidos,lista_precios,index)

  return lista_productos_repetidos

llenaCampoPrecioUnitarioProductoRepetido = (numero_renglon_producto_repetido,lista_productos_repetidos,lista_precios,index) ->
  for numero_de_renglon_de_elemento_repetido in lista_productos_repetidos
    $('#precio_unitario_calculadora_' + numero_de_renglon_de_elemento_repetido).val(lista_precios[index])

actualizaPrecioRenglon = (longitud_total, piezas, numero_de_campo,lista_productos_repetidos) ->

  p_unit = Number($('#precio_unitario_calculadora_' + numero_de_campo).val())
  $('#iva_precio_unitario_calculadora_' + numero_de_campo).val((p_unit*0.16).toFixed(2))
  $('#precio_unitario_neto_calculadora_' + numero_de_campo).val((p_unit*1.16).toFixed(2))

  precio_por_pieza = (p_unit * longitud_total + piezas * 0.3 * p_unit)/piezas
  if isNaN(precio_por_pieza) then precio_por_pieza = 0
  $('#precio_por_pieza_' + numero_de_campo).val((precio_por_pieza).toFixed(2))
  $('#iva_precio_por_pieza_calculadora_' + numero_de_campo).val((precio_por_pieza*0.16).toFixed(2))
  $('#precio_por_pieza_neto_calculadora_' + numero_de_campo).val((precio_por_pieza*1.16).toFixed(2))

  $('#precio_sin_iva_' + numero_de_campo).val((p_unit * longitud_total + piezas * 0.3 * p_unit).toFixed(2))
  $('#iva_renglon_' + numero_de_campo).val(Number(($('#precio_sin_iva_' + numero_de_campo).val()) * 0.16).toFixed(2))
  $('#precio_neto_' + numero_de_campo).val((Number($('#precio_sin_iva_' + numero_de_campo).val()) + Number($('#iva_renglon_' + numero_de_campo).val())).toFixed(2))

  if lista_productos_repetidos.length != 0
    for numero_de_renglon_de_elemento_repetido in lista_productos_repetidos
      $('#iva_precio_unitario_calculadora_' + numero_de_renglon_de_elemento_repetido).val((p_unit*0.16).toFixed(2))
      $('#precio_unitario_neto_calculadora_' + numero_de_renglon_de_elemento_repetido).val((p_unit*1.16).toFixed(2))
      longitud_elemento_repetido = Number($('#cantidad_calculadora_' + numero_de_renglon_de_elemento_repetido).val()) * Number($('#numero_piezas_calculadora_' + numero_de_renglon_de_elemento_repetido).val())
      piezas_elemento_repetido = Number($('#numero_piezas_calculadora_' + numero_de_renglon_de_elemento_repetido).val())
      precio_por_pieza_elemento_repetido = (p_unit * longitud_elemento_repetido + piezas_elemento_repetido * 0.3 * p_unit)/piezas_elemento_repetido
      if isNaN(precio_por_pieza_elemento_repetido) then precio_por_pieza_elemento_repetido = 0
      $('#precio_por_pieza_' + numero_de_renglon_de_elemento_repetido).val((precio_por_pieza_elemento_repetido).toFixed(2))
      $('#iva_precio_por_pieza_calculadora_' + numero_de_renglon_de_elemento_repetido).val((precio_por_pieza_elemento_repetido*0.16).toFixed(2))
      $('#precio_por_pieza_neto_calculadora_' + numero_de_renglon_de_elemento_repetido).val((precio_por_pieza_elemento_repetido*1.16).toFixed(2))
      $('#precio_sin_iva_' + numero_de_renglon_de_elemento_repetido).val((p_unit * longitud_elemento_repetido + piezas_elemento_repetido * 0.3 * p_unit).toFixed(2))
      $('#iva_renglon_' + numero_de_renglon_de_elemento_repetido).val(Number(($('#precio_sin_iva_' + numero_de_renglon_de_elemento_repetido).val()) * 0.16).toFixed(2))
      $('#precio_neto_' + numero_de_renglon_de_elemento_repetido).val((Number($('#precio_sin_iva_' + numero_de_renglon_de_elemento_repetido).val()) + Number($('#iva_renglon_' + numero_de_renglon_de_elemento_repetido).val())).toFixed(2))

actualizaPrecioTotal = () ->

  [subtotal, iva, total] = [0,0,0]

  $('*[id*=precio_sin_iva_]').each ->
    subtotal += Number($(this).val())

  $('*[id*=iva_renglon_]').each ->
    iva += Number($(this).val())

  $('*[id*=precio_neto_]').each ->
    total += Number($(this).val())

  $('#subtotal_general').val(subtotal.toFixed(2))
  $('#iva_general').val(iva.toFixed(2))
  $('#total_general').val(total.toFixed(2))
  $('#total_con_envio').val((total + Number($('#envio').val())).toFixed(2))

calculaPrecioConEnvio = () ->

  $('#total_con_envio').val(Number($('#envio').val()) + Number($('#total_general').val()))

prellenarEnvioEnCalculadora = () ->
    $('#envio').val('65.5')
