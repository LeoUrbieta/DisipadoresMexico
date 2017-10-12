class ProductosController < ApplicationController
  
  def index
    @productos = Producto.all
  end
  
  def new
    @producto = Producto.new
  end
  
  def edit
    @producto = Producto.find(params[:id])
  end
  
  def create
    @producto = Producto.new(producto_params)
    
    if @producto.save
      redirect_to productos_path
    else
      render 'new'
    end
  end
  
  def update
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
    params.require(:producto).permit(:nombre_producto, :clave_sat, :precio_unitario_mercado_libre, :precio_unitario_shopify)
  end
  
end
