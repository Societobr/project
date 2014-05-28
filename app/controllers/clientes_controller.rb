class ClientesController < ApplicationController
  layout 'dashboard', except: [:new, :create] # new ~> layouts/application
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]
  before_filter :authorize, except: [:new, :create]
  before_filter :plano_escolhido?, only: [:new]

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
    @id_sessao = CheckoutController.get_id_sessao
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

    if @cliente.valid? && cliente_aceitou_termo? && @cliente.save
      parametrosPagamento = get_parametros_validos()
      resposta = CheckoutController.start(parametrosPagamento)
      
      if sucesso?(resposta)
        flash[:notice] = 'Cadastro efetuado com sucesso. Obrigado!'
        render :new
      else
        Cliente.delete(@cliente)
        @id_sessao = CheckoutController.get_id_sessao
        render :new
      end
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
      params.require(:cliente).permit(
        :nome,
        :ddd,
        :email,
        :cpf,
        :nascimento,
        :telefone,
        :cep,
        :estado,
        :cidade,
        :bairro,
        :rua,
        :numero,
        :complemento,
        :cupom)
    end

    def pagamento_params
      params.require(:pagamento).permit(
        :nome_cartao,
        :ddd_cartao,
        :telefone_cartao,
        :cpf_cartao,
        :nascimento_cartao,
        :cep_cartao,
        :cidade_cartao,
        :estado_cartao,
        :bairro_cartao,
        :rua_cartao,
        :numero_endereco_cartao,
        :complemento_cartao,
        :parcelas,
        :tokenIdentificadorCartao,
        :identificador_vendedor,
        :meio_pagamento
        )
    end

    def cliente_aceitou_termo?
      if params[:aceite]
        true
      else
        @cliente.errors.messages.store :aceite, ['os termos'] 
        false
      end
    end

    def get_parametros_validos
      parametros = cliente_params
      parametros.merge!(pagamento_params)
      parametros.merge!(plano_params)
      parametros.store(:reference, @cliente.registro)
      parametros.store(:banco, params[:banco])
      return parametros
    end

    def sucesso?(resposta)
      if resposta.class == Array    # lista de erros
        flash[:error] = resposta.join("\n")
        return false
      else resposta.class == String # sucesso
        return true
      end
    end

    def plano_escolhido?
      planos_ids = {'MENSAL' => '001', 'ANUAL' => '002', 'AMIGO' => '003'}
      planos_precos = {'MENSAL' => 1.01,'ANUAL' => 1.02, 'AMIGO' => 1.03}
      planos_vigencia = {'MENSAL' => 30,'ANUAL' => 60, 'AMIGO' => 90}
      
      if planos_precos.keys.include?(params[:plano])
        plano = params[:plano]
        id = planos_ids[plano]
        preco = planos_precos[plano]
        vigencia = planos_vigencia[plano]
        
        session[:plano_id] = id
        session[:plano_nome] = plano
        session[:plano_preco] = preco
        session[:plano_vigencia] = vigencia
      else
        redirect_to nossos_planos_path
      end

    end

    def plano_params
      {id_plano: session[:plano_id], plano: session[:plano_nome], preco: session[:plano_preco]}
    end
end
