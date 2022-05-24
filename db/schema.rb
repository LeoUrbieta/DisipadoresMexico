# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_23_175456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clientes", force: :cascade do |t|
    t.string "nombre"
    t.string "rfc"
    t.string "calle"
    t.string "numero_exterior"
    t.string "numero_interior"
    t.string "colonia"
    t.string "municipio_delegacion"
    t.string "ciudad"
    t.string "codigo_postal"
    t.string "telefono"
    t.string "email"
    t.string "persona_contacto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "estado"
  end

  create_table "egresos", force: :cascade do |t|
    t.text "descripcion"
    t.string "emisor"
    t.decimal "cantidad"
    t.text "notas_adicionales"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha"
    t.boolean "iva_acreditable_bool"
  end

  create_table "productos", force: :cascade do |t|
    t.string "nombre_producto"
    t.string "clave_sat"
    t.string "precio_1"
    t.string "precio_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha_de_compra"
    t.integer "cantidad_comprada"
    t.decimal "precio"
    t.text "notas_adicionales"
    t.integer "perdidas"
    t.string "columna_relacionada_en_ventas"
    t.string "precio_3"
    t.string "precio_4"
    t.string "precio_5"
    t.string "precio_6"
    t.string "precio_7"
    t.string "precio_8"
    t.decimal "costo_unitario"
    t.boolean "costo_actual"
  end

  create_table "ventas", force: :cascade do |t|
    t.date "fecha"
    t.integer "longitud_75mm"
    t.integer "longitud_87mm"
    t.integer "longitud_136mm"
    t.integer "cantidad_peltier"
    t.integer "cantidad_pasta_termica"
    t.decimal "precio_75mm"
    t.decimal "precio_87mm"
    t.decimal "precio_136mm"
    t.decimal "precio_peltier"
    t.decimal "precio_pasta_termica"
    t.decimal "subtotal"
    t.decimal "descuento_75mm"
    t.decimal "descuento_87mm"
    t.decimal "descuento_136mm"
    t.decimal "descuento_peltier"
    t.decimal "descuento_pasta_termica"
    t.decimal "total_productos"
    t.decimal "envio_explicito"
    t.decimal "total_pagado_por_cliente"
    t.decimal "comisiones"
    t.decimal "comision_envio"
    t.decimal "total_post_comisiones"
    t.string "medio_de_venta"
    t.boolean "facturado"
    t.string "folio_factura"
    t.text "notas_adicionales"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "cliente_id"
    t.integer "cortes_75mm"
    t.integer "cortes_87mm"
    t.integer "cortes_136mm"
    t.decimal "dinero_anadido"
    t.integer "longitud_28mm"
    t.integer "longitud_50mm"
    t.integer "longitud_100mm"
    t.integer "longitud_220mm"
    t.decimal "precio_28mm"
    t.decimal "precio_50mm"
    t.decimal "precio_100mm"
    t.decimal "precio_220mm"
    t.decimal "descuento_28mm"
    t.decimal "descuento_50mm"
    t.decimal "descuento_100mm"
    t.decimal "descuento_220mm"
    t.integer "cortes_28mm"
    t.integer "cortes_50mm"
    t.integer "cortes_100mm"
    t.integer "cortes_220mm"
    t.decimal "iva_prod"
    t.decimal "iva_envios"
    t.decimal "iva_anadido"
    t.boolean "iva_comision_bool"
    t.boolean "iva_envio_bool"
    t.decimal "costo_28mm"
    t.decimal "costo_50mm"
    t.decimal "costo_75mm"
    t.decimal "costo_87mm"
    t.decimal "costo_100mm"
    t.decimal "costo_136mm"
    t.decimal "costo_220mm"
    t.decimal "costo_peltier"
    t.decimal "costo_pasta_termica"
    t.decimal "longitud_125mm"
    t.decimal "longitud_75mm_anod"
    t.decimal "longitud_87mm_anod"
    t.decimal "precio_125mm"
    t.decimal "precio_75mm_anod"
    t.decimal "precio_87mm_anod"
    t.decimal "descuento_125mm"
    t.decimal "descuento_75mm_anod"
    t.decimal "descuento_87mm_anod"
    t.decimal "cortes_125mm"
    t.decimal "cortes_75mm_anod"
    t.decimal "cortes_87mm_anod"
    t.decimal "costo_125mm"
    t.decimal "costo_75mm_anod"
    t.decimal "costo_87mm_anod"
    t.decimal "longitud_230mm"
    t.decimal "longitud_75mm_negro"
    t.decimal "precio_230mm"
    t.decimal "precio_75mm_negro"
    t.decimal "descuento_230mm"
    t.decimal "descuento_75mm_negro"
    t.decimal "cortes_230mm"
    t.decimal "cortes_75mm_negro"
    t.decimal "costo_230mm"
    t.decimal "costo_75mm_negro"
  end

end
