class VentasController < ApplicationController
  
  http_basic_authenticate_with name: "leo", password: "secreto", except: [:index, :show]
  
  def index
    @ventas = Venta.paginate(page: params[:page], per_page: 20).order('fecha DESC')
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
    @venta = Venta.new(venta_params)
    
    if @venta.save
      redirect_to ventas_path
    else
      render 'new'
    end
  end
  
  def update
    @venta = Venta.find(params[:id])
    
    if @venta.update(venta_params)
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
                                  :descuento_peltier, :descuento_pasta_termica, :total_productos, :envio_explicito, :envio_agregado_a_precio_productos,
                                  :total_pagado_por_cliente, :comisiones, :comision_envio, :total_post_comisiones, :medio_de_venta, :facturado,
                                  :folio_factura, :notas_adicionales, :devolucion ,:cliente_id, :cortes_75mm, :cortes_87mm, :cortes_136mm, :dinero_anadido)
  end
  
end
