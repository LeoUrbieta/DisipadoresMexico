class EgresosController < ApplicationController
  
  http_basic_authenticate_with name: "leo", password: "secreto", except: [:index, :show]
  
  def index
    @egresos = Egreso.paginate(page: params[:page], per_page: 20).order('fecha DESC')
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
    params.require(:egreso).permit(:fecha, :descripcion, :emisor, :cantidad, :iva_acreditable_bool, :notas_adicionales)
  end

end