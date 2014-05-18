class AtividadesController < ApplicationController
  layout 'dashboard'
  before_filter :authorize

  def index
  	@atividades = Atividade.all
  end

  def new
  	@atividade = Atividade.new
  end

  def create
    @atividade = Atividade.new(get_valid_args)
    
    if @atividade.save
      flash[:notice] = 'Registro gravado'
    end

    redirect_to :atividades_new
  end

  private
  
  def atividade_params
    params.require(:atividade).permit('cpf_ou_#registro', :preco_total, :valor_desconto)
  end

  def get_cliente
    id = atividade_params['cpf_ou_#registro']
    Cliente.where("cpf = ? OR registro = ?", id, id).first
  end

  def get_valid_args
    cliente = get_cliente
    parceiro = current_user # definido em application_controller
    validArgs = atividade_params.except('cpf_ou_#registro')
    validArgs.store(:cliente_id, cliente.id) if cliente
    validArgs.store(:user_id, parceiro.id)
    return validArgs
  end
end
