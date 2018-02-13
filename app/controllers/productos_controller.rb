class ProductosController < ApplicationController
  
  http_basic_authenticate_with name: "leo", password: "secreto", except: [:index, :show]
  
  def index
    @productos = Producto.all.order("fecha_de_compra")
  end
  
  def new
    @producto = Producto.new
    @indices = Producto.buscar_indices(Venta.column_names)
  end
  
  def edit
    @producto = Producto.find(params[:id])
    @indices = Producto.buscar_indices(Venta.column_names)
  end
  
  def create
    @indices = Producto.buscar_indices(Venta.column_names)
    @producto = Producto.new(producto_params)
    
    if @producto.save
      redirect_to productos_path
    else
      render 'new'
    end
  end
  
  def update
    @indices = Producto.buscar_indices(Venta.column_names)
    @producto = Producto.find(params[:id])
    
    if @producto.update(producto_params)
      redirect_to productos_path
    else
      render 'edit'
    end
  end
  
  def show
    @producto = Producto.find(params[:id])
  end
  
  def destroy
    @producto = Producto.find(params[:id])
    @producto.destroy
    redirect_to productos_path
  end
  
  private
  
  def producto_params
    params[:producto][:nombre_producto] = params[:producto][:nombre_producto].upcase
    params.require(:producto).permit(:nombre_producto, :clave_sat, :precio_unitario_mercado_libre, 
                                     :precio_unitario_shopify, :perdidas, :cantidad_comprada, :precio,
                                     :fecha_de_compra, :notas_adicionales, :columna_relacionada_en_ventas)
    
  end
  
end
