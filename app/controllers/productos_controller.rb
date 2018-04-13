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
    asignaTrueAUnicoProducto
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
    asignaTrueAUnicoProducto
    
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
    @productos = Producto.all.order("fecha_de_compra")
    @producto = Producto.find(params[:id])
    unless esUnicoProducto(params[:id])
      asignaOtroProducto(params[:id])
      @producto.destroy
      redirect_to productos_path
    else
      flash[:notice] = "Ese producto no puede eliminarse ya que es único"
      redirect_to productos_path
    end
      
    
  end
  
  private
  
  def producto_params
    params[:producto][:nombre_producto] = params[:producto][:nombre_producto].upcase
    params.require(:producto).permit(:nombre_producto, :clave_sat, :precio_1, :precio_2, :precio_3,
                                     :precio_4, :precio_5, :precio_6, :precio_7, :precio_8,
                                     :perdidas, :cantidad_comprada, :precio,
                                     :fecha_de_compra, :notas_adicionales, :columna_relacionada_en_ventas,
                                     :costo_unitario, :costo_actual)
    
  end
  
  def asignaTrueAUnicoProducto
    esUnico = Producto.asignaTrueAUnSoloProducto(params[:producto][:costo_actual],params[:producto][:columna_relacionada_en_ventas],params[:id])
    if esUnico == "true"
      params[:producto][:costo_actual] = "true"
      return true
    elsif params[:producto][:columna_relacionada_en_ventas].empty?
      params[:producto][:costo_actual] = "false"
    end
  end
  
  def esUnicoProducto(id)
    return Producto.buscaSiEsUnicoParaEliminar(id)
  end
  
  def asignaOtroProducto(id)
    Producto.asignaTrueAOtroProducto(id)
  end
  
end
