class AtividadesController < ApplicationController
  layout 'dashboard'
  before_filter :authorize_admin, only: [:index]
  before_filter :authorize_parceiro, except: [:index]

  def index
  	@atividades = Atividade.all
    @de = Date.new(2000, 01, 01)
    @ate = Date.current.at_end_of_day
  end

  def filter
    @de = (params[:de] == "" ? Date.new(2000, 01, 01) : params[:de].to_date.at_beginning_of_day)
    @ate = (params[:ate] == "" ? Date.current.at_end_of_day : params[:ate].to_date.at_end_of_day)
    @parc_nome = params[:parceiro]
    @atividades = Atividade.
                    where(created_at: @de..@ate).
                    joins(:user).
                    merge( User.where("username LIKE '#{@parc_nome}%'") )
    
    render :index
  end

  def new
  	@atividade = Atividade.new
  end

  def create
    @atividade = Atividade.new(get_atividade_params)
    
    if @atividade.save
      flash.now[:notice] = 'Registro gravado'
    else
      flash.now[:error] = @atividade.errors.to_a.join("\n")
    end

    render :new
  end

  # Method called via AJAX to check whether the
  # client exists or not.
  def find_client
    cliente = get_cliente(params[:id])

    respond_to do |format|
      format.json {render json: {client: cliente}}
    end
  end

  private

  def get_atividade_params
    parametros = atividade_params
    cliente = get_cliente(parametros['id'])
    parceiro = current_user

    ativ = {user_id: current_user.id,
            cliente_id: cliente.id,
            preco_total: parametros[:preco_total].gsub(',', '.').to_f,
            valor_desconto: parametros[:valor_desconto].gsub(',', '.').to_f,
            }
  end
  
  def atividade_params
    params.require(:atividade).permit('id', :preco_total, :valor_desconto)
  end

  def get_cliente(id)
    Cliente.where("cpf = ? OR registro = ?", id, id).first
  end
end
