class ClientesController < ApplicationController
  layout 'dashboard', except: [:new, :create] # new ~> layouts/application
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]
  before_filter :authorize, except: [:new, :create]

  # GET /clientes
  # GET /clientes.json
  def index
    @clientes = Cliente.all

    respond_to do |format|
      format.html # show index.html.erb
      format.csv { send_data @clientes.to_csv }
    end
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
  end

  # Renderiza layout para cadastro de usuário pelo próprio admin
  def new_admin
    @cliente = Cliente.new
  end

  # GET /clientes/1/edit
  def edit
  end

  # Valida informações inseridas pelo admin no cadastro de usuário
  def create_admin
    @cliente = Cliente.new(cliente_params)

    if @cliente.save
      redirect_to @cliente, notice: 'Cliente criado com sucesso.'
    else
      render :new_admin
    end
  end

  # POST /clientes
  def create
    @cliente = Cliente.new(cliente_params)
    
    if (@cliente.valid? || cliente_aceitou_termo?) && @cliente.save
      redirect_to nossos_planos_path, alert: 'Quase acabando. Escolha seu plano.'
    else
      render :new
    end
  end

  # PATCH/PUT /clientes/1
  # PATCH/PUT /clientes/1.json
  def update
    if @cliente.update(cliente_params)
      redirect_to @cliente, notice: 'Cliente atualizado.'
    else
      render :edit
    end
  end

  # DELETE /clientes/1
  # DELETE /clientes/1.json
  def destroy
    @cliente.destroy
    redirect_to clientes_url, notice: 'Cliente deletado.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cliente_params
      params.require(:cliente).permit(:nome, :sobrenome, :email, :cpf, :nascimento, :telefone, :cep, :estado, :cidade, :endereco)
    end

    def cliente_aceitou_termo?
      if params[:aceite]
        true
      else
        @cliente.errors.messages.store :aceite, ['os termos'] 
        false
      end
    end
end
