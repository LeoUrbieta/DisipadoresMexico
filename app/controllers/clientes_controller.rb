class ClientesController < ApplicationController

  def index
    @clientes = Cliente.paginate(page: params[:page], per_page: 20)
  end

  def new
    @cliente = Cliente.new
  end

  def edit
    @cliente = Cliente.find(params[:id])
  end

  def create
    @cliente = Cliente.new(cliente_params)

    if @cliente.save
      redirect_to new_venta_path
    else
      render 'new'
    end
  end

  def update
    @cliente = Cliente.find(params[:id])

    if @cliente.update(cliente_params)
      redirect_to clientes_path
    else
      render 'edit'
    end
  end

  def show
    @cliente = Cliente.find(params[:id])
  end

  def destroy
    @cliente = Cliente.find(params[:id])
    @cliente.destroy
    redirect_to clientes_path
  end

  private

  def cliente_params
    params[:cliente][:nombre] = params[:cliente][:nombre].mb_chars.upcase.to_s
    #params[:cliente][:persona_contacto] = params[:cliente][:persona_contacto].mb_chars.upcase.to_s
    params.require(:cliente).permit(:nombre, :rfc, :calle, :numero_exterior, :numero_interior, :colonia, :municipio_delegacion,
    :ciudad, :estado ,:codigo_postal, :telefono, :email, :persona_contacto)
  end


end
