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

ActiveRecord::Schema.define(version: 20171025151456) do

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
    t.string "string"
  end

  create_table "egresos", force: :cascade do |t|
    t.text "descripcion"
    t.string "emisor"
    t.decimal "cantidad"
    t.text "notas_adicionales"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha"
  end

  create_table "productos", force: :cascade do |t|
    t.string "nombre_producto"
    t.string "clave_sat"
    t.string "precio_unitario_mercado_libre"
    t.string "precio_unitario_shopify"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.decimal "envio"
    t.boolean "envio_incluido_en_precio"
    t.decimal "total_envio_incluido_en_precio_mas_total_productos"
    t.boolean "envio_a_mi_cargo"
    t.decimal "total_incluyendo_envio"
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
  end

end
