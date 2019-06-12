class VentasController < ApplicationController
  
  def index
    @ventas = Venta.paginate(page: params[:page], per_page: 20).order('fecha DESC, id')
  end
  
  def new
    @clientes = Cliente.paginate(page: params[:page], per_page: 10)
    @venta = Venta.new
    @precios = Producto.busca_precios()
  end
  
  def edit
    @clientes = Cliente.paginate(page: params[:page], per_page: 10)
    @venta = Venta.find(params[:id])
    @precios = Producto.busca_precios()
  end
  
  def create
    @clientes = Cliente.paginate(page: params[:page], per_page: 10)
    costo_productos = Producto.fetchCostos()
    @venta = Venta.new(venta_params.merge(costo_productos))
    @precios = Producto.busca_precios()
    
    if @venta.save
      redirect_to ventas_path
    else
      render 'new'
    end
  end
  
  def update
    @clientes = Cliente.paginate(page: params[:page], per_page: 10)
    @venta = Venta.find(params[:id])
    @precios = Producto.busca_precios()
    costo_productos = Producto.fetchCostos()
    
    if @venta.update(venta_params.merge(costo_productos))
      redirect_to ventas_path
    else
      render 'edit'
    end
  end
  
  def show
    @venta = Venta.find(params[:id])
  end
  
  def destroy
    @venta = Venta.find(params[:id])
    @venta.destroy
    redirect_to ventas_path
  end
  
  private
  
  def venta_params
    params.require(:venta).permit(:fecha, :longitud_75mm, :longitud_87mm, :longitud_136mm, :cantidad_peltier, :cantidad_pasta_termica, :precio_75mm, :precio_87mm,
                                  :precio_136mm, :precio_peltier, :precio_pasta_termica, :subtotal, :descuento_75mm, :descuento_87mm, :descuento_136mm,
                                  :descuento_peltier, :descuento_pasta_termica, :total_productos, :envio_explicito,
                                  :total_pagado_por_cliente, :comisiones, :comision_envio, :total_post_comisiones, :medio_de_venta, :facturado,
                                  :folio_factura, :notas_adicionales,:cliente_id, :cortes_75mm, :cortes_87mm, :cortes_136mm, :dinero_anadido,
                                  :longitud_28mm, :precio_28mm, :descuento_28mm, :cortes_28mm,
                                  :longitud_50mm, :precio_50mm, :descuento_50mm, :cortes_50mm,
                                  :longitud_100mm, :precio_100mm, :descuento_100mm, :cortes_100mm,
                                  :longitud_220mm, :precio_220mm, :descuento_220mm, :cortes_220mm,
                                  :longitud_125mm, :precio_125mm, :descuento_125mm, :cortes_125mm,
                                  :longitud_75mm_anod, :precio_75mm_anod, :descuento_75mm_anod, :cortes_75mm_anod,
                                  :longitud_87mm_anod, :precio_87mm_anod, :descuento_87mm_anod, :cortes_87mm_anod,
                                  :longitud_75mm_negro, :precio_75mm_negro, :descuento_75mm_negro, :cortes_75mm_negro,
                                  :longitud_230mm, :precio_230mm, :descuento_230mm, :cortes_230mm,
                                  :iva_prod, :iva_envios, :iva_anadido, :iva_comision_bool, :iva_envio_bool)
  end
  
end
