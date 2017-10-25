class EgresosController < ApplicationController
  
  def index
    @egresos = Egreso.all.order("fecha")
  end
  
  def new
    @egreso = Egreso.new
  end
  
  def edit
    @egreso = Egreso.find(params[:id])
  end
  
  def create
    @egreso = Egreso.new(egreso_params)
    
    if @egreso.save
      redirect_to egresos_path
    else
      render 'new'
    end
  end
  
  def update
    @egreso = Egreso.find(params[:id])
    
    if @egreso.update(egreso_params)
      redirect_to egresos_path
    else
      render 'edit'
    end
  end
  
  def show
    @egreso = Egreso.find(params[:id])
  end
  
  def destroy
    @egreso = Egreso.find(params[:id])
    @egreso.destroy
    redirect_to egresos_path
  end
  
  private
  
  def egreso_params
    params.require(:egreso).permit(:fecha, :descripcion, :emisor, :cantidad, :notas_adicionales)
  end

end