class Producto < ApplicationRecord

  validates :nombre_producto, :precio_1, :precio_2, :precio_3,
            :precio_4, :precio_5, :precio_6, :precio_7, :precio_8,
            :cantidad_comprada, :perdidas, :costo_unitario,
             presence: true

  validates_inclusion_of :costo_actual, in: [true, false]

  #default_scope -> { order(fecha_de_compra: :asc)}

  def self.buscar_indices(nombre_columnas)

    lista_nombres = Array.new

    nombre_columnas.each_index.select{|i| nombre_columnas[i].include?("longitud") || nombre_columnas[i].include?("cantidad")}.each do |indice|
      lista_nombres << nombre_columnas[indice]
    end

    return lista_nombres

  end

  def self.cantidad_restante()

    cantidad_restante = Hash.new
    cantidad_comprada = Hash.new

    Producto.all.each do |producto|

      nombre_columna = producto.columna_relacionada_en_ventas

      if(nombre_columna != "")
        cantidad_restante[nombre_columna] = Array.new
        if(cantidad_comprada[nombre_columna] != nil)
          cantidad_comprada[nombre_columna] = cantidad_comprada[nombre_columna] + producto.cantidad_comprada
        else
          cantidad_comprada[nombre_columna] = producto.cantidad_comprada
        end
      end
    end

    Producto.all.each do |producto|

      nombre_columna = producto.columna_relacionada_en_ventas

      if(nombre_columna != "")
        if(cantidad_restante[nombre_columna] === [])
          if(nombre_columna.include? "longitud")
            nombre_cortes_producto = Producto.quitaLongitudYPonCortesEnString (nombre_columna)
            longitudPerdidaPorCortes = (Venta.all.sum(nombre_cortes_producto) * 0.3 ).round
            cantidad_restante[nombre_columna] = [cantidad_comprada[nombre_columna],
                                                Venta.all.sum(nombre_columna),
                                                longitudPerdidaPorCortes,
                                                producto.perdidas,
                                                cantidad_comprada[nombre_columna] -
                                                Venta.all.sum(nombre_columna) -
                                                longitudPerdidaPorCortes -
                                                producto.perdidas]
          else
            cantidad_restante[nombre_columna] = [cantidad_comprada[nombre_columna],
                                                Venta.all.sum(nombre_columna),
                                                producto.perdidas,
                                                cantidad_comprada[nombre_columna] -
                                                Venta.all.sum(nombre_columna) -
                                                producto.perdidas]
          end
        else
          if(nombre_columna.include? "longitud")
          cantidad_restante[nombre_columna] = cantidad_restante[nombre_columna].zip([0,0,0,producto.perdidas,-producto.perdidas]).map { |x,y| x + y }
          else
          cantidad_restante[nombre_columna] = cantidad_restante[nombre_columna].zip([0,0,producto.perdidas,-producto.perdidas]).map { |x,y| x + y }
          end
        end
      end
    end

    return cantidad_restante

  end

  def self.busca_precios()

    precios = Hash.new

    Producto.where("costo_actual = :costo_boolean",{costo_boolean: true}).each do |producto|

      if producto.notas_adicionales.include? "DESCONTINUADO"
        next
      else
        array_precios = Array.new
        array_precios[0] = producto.precio_1
        array_precios[1] = producto.precio_2
        array_precios[2] = producto.precio_3
        array_precios[3] = producto.precio_4
        array_precios[4] = producto.precio_5
        array_precios[5] = producto.precio_6
        array_precios[6] = producto.precio_7
        array_precios[7] = producto.precio_8
        precios[producto.columna_relacionada_en_ventas] = array_precios
      end
    end

    return precios
  end

  private

  def self.quitaLongitudYPonCortesEnString (nombre)
    articulo = nombre[8..-1]
    return "cortes" << articulo
  end

  def self.fetchCostos()
    costos_actuales = Hash.new

    productos_con_costo_actual = Producto.where("costo_actual = :costo_boolean",{costo_boolean: true})

    productos_con_costo_actual.each do |producto|
      costos_actuales[producto.columna_relacionada_en_ventas.sub("longitud","costo").sub("cantidad","costo")] = producto.costo_unitario
    end

    return costos_actuales
  end

  def self.asignaTrueAUnSoloProducto(costo_actual_boolean, nombre_producto, index_producto)

    if nombre_producto.empty?
      return "false"
    end

    if costo_actual_boolean == "true"
      producto_con_true_actual = Producto.where("costo_actual = :costo_boolean AND columna_relacionada_en_ventas = :nombre AND id != :index",{costo_boolean: true, nombre: nombre_producto, index: index_producto})
      unless producto_con_true_actual.empty?
        producto_a_cambiar = Producto.find(producto_con_true_actual.last.id)
        producto_a_cambiar.costo_actual = false
        producto_a_cambiar.save
      end
      return "true"
    else
      producto_con_true_actual = Producto.where("costo_actual = :costo_boolean AND columna_relacionada_en_ventas = :nombre AND id != :index",{costo_boolean: true, nombre: nombre_producto, index: index_producto})
      if index_producto.nil?
        return "false"
      elsif producto_con_true_actual.empty?
        return "true"
      end
    end
  end

  def self.buscaSiEsUnicoParaEliminar(ident)

    if Producto.find(ident).columna_relacionada_en_ventas.empty?
      return true
    end

    producto = Producto.where("columna_relacionada_en_ventas = :producto AND id != :index",{producto: Producto.find(ident).columna_relacionada_en_ventas, index: ident})
    if producto.empty?
      return true
    else
      return false
    end
  end

  def self.asignaTrueAOtroProducto(ident)
    if Producto.find(ident).costo_actual == "false"
      return false
    else
      producto_a_cambiar = Producto.where("columna_relacionada_en_ventas = :producto AND id != :index",{producto: Producto.find(ident).columna_relacionada_en_ventas, index: ident})
      producto = Producto.find(producto_a_cambiar.last.id)
      producto.costo_actual = true
      producto.save
    end
  end


end
