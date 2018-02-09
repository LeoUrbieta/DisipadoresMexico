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
    
    
  
  
 

