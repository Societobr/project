class AtividadesController < ApplicationController
  layout Proc.new { params[:action] == 'index' ? 'dashboard/dashboard' : 'parceiro/dashboard'}
  before_filter :authorize_admin, only: [:index]
  before_filter :authorize_parceiro, except: [:index]

  def index
  	@atividades = filter(params[:filtro]) || Atividade.all
    get_zip_reports if params[:commit] == "Relatório"
    @atividades = @atividades.paginate(:page => params[:page], :per_page => 10)
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

    {
      user_id: current_user.id,
      cliente_id: cliente.id,
      preco_total: parametros[:preco_total].gsub(',', '.').to_f,
      valor_desconto: parametros[:valor_desconto].gsub(',', '.').to_f
    }
  end

  def filter(filtro)
    set_default_filter_values

    unless filtro.nil?
      @de = (filtro[:de] == "" ? Date.new(2000, 01, 01) : filtro[:de].to_date.at_beginning_of_day)
      @ate = (filtro[:ate] == "" ? Date.current.at_end_of_day : filtro[:ate].to_date.at_end_of_day)
      @parc_nome = filtro[:parceiro]
      Atividade.where(created_at: @de..@ate).
                joins(:user).
                merge( User.where("username LIKE '#{@parc_nome}%'") )
    end
  end

  def set_default_filter_values
    @de = Date.new(2000, 01, 01)
    @ate = Date.current.at_end_of_day
  end

  def get_zip_reports
    file = Zip::ZipOutputStream.write_buffer do |zos|
      zos.put_next_entry 'societo.csv'
      zos.write Atividade.relat_do_admin(@atividades)
      
      @atividades.group_by(&:user_id).each_value do |array_atividade|
        zos.put_next_entry(array_atividade[0].user.username + '.csv')
        zos.write Atividade.relat_do_parc(array_atividade)
      end
    end

    file.rewind
    binary_data = file.sysread
    send_data binary_data, filename: "Atividades DE #{@de.to_s_br.gsub('/','-')} ATÉ #{@ate.to_s_br.gsub('/','-')}.zip"
  end
  
  def atividade_params
    params.require(:atividade).permit('id', :preco_total, :valor_desconto)
  end

  def get_cliente(id)
    Cliente.where("cpf = ? OR registro = ? OR num_cartao = ?", id, id, id).first
  end

end
