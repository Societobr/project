class ClientesController < ApplicationController
  layout 'dashboard/dashboard', except: [:new, :create, :new_sem_pagamento, :create_sem_pagamento, :new_amigo, :create_amigo, :consultar_status_cadastro, :status_cadastro] # new ~> layouts/application
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]
  before_filter :authorize_admin, except: [:new, :create, :cupom, :cards_brand, :new_sem_pagamento, :create_sem_pagamento, :new_amigo, :create_amigo, :consultar_status_cadastro, :status_cadastro]
  before_filter :plano_escolhido?, only: [:new, :new_sem_pagamento]
  before_filter :hash_amigo_valido?, only: [:new_amigo]

  CUPOM_CODE = ['societo50']

  # GET /clientes
  # GET /clientes.json
  def index
    @clientes = filter(params[:filter]) || Cliente.includes(:plano, :atividades, historicos: [:status_transacao_pag_seguro]).all # Cliente.all
    
    respond_to do |format|
      format.html # show index.html.erb
      format.csv { send_data @clientes.to_csv }
    end
  end

  def filter(filtro)
    Cliente.includes(:plano, :atividades, historicos: [:status_transacao_pag_seguro]).send filtro if filtro
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
  end

  def consultar_status_cadastro
    @cliente = Cliente.new
  end

  def status_cadastro
    @cliente = Cliente.find_by_cpf(params[:cliente][:cpf])
    if @cliente
      flash.now[:notice] = "Status: #{@cliente.status_plano}\n#{'Válido até:' + @cliente.expira_em.strftime('%d/%m/%Y') if !@cliente.aguard_pag?}"
    else
      flash.now[:error] = "CPF não cadastrado em nossa base de dados."
      @cliente = Cliente.new
    end
    render :consultar_status_cadastro
  end

  # GET /clientes/new
  def new
    @cliente = (session[:cliente_id] ? Cliente.find(session[:cliente_id]) : Cliente.new)
    @cliente.cupom = nil
    @id_sessao = CheckoutController.get_id_sessao
    session[:cupom_discount] = nil
    session[:cupom_code] = nil
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
    @cliente = Cliente.new(cliente_params_admin)

    if @cliente.save
      redirect_to @cliente, notice: 'Cliente criado com sucesso.'
    else
      render :new_admin
    end
  end

  # POST /clientes 
  def create
    @cliente = (renovacao? ? Cliente.find(session[:cliente_id]) : Cliente.new(cliente_params))

    if renovacao?

      if validate_entries { trata_se_cadastro_amigo_valido? } && @cliente.update(cliente_params)
        resp, resposta = realiza_pagamento()

        if sucesso?(resposta)
          grava_info_amigo if session[:plano_duplo]
          
          if(pagamento_params[:meio_pagamento] == 'debito')
            flash[:notice] = 'Dados atualizados com sucesso. Você receberá um email de confirmação quando o pagamento for identificado. Aproveite e veja nossa lista de parceiros.'
            redirect_to link_pagamento(resp)
            return
          elsif(pagamento_params[:meio_pagamento] == 'boleto')
            flash[:notice] = 'O boleto para pagamento foi enviado para o seu email. Obrigado!'
            redirect_to cidades_belo_horizonte_path
            return
          end
          
          flash[:notice] = 'Dados atualizados com sucesso. Você receberá um email de confirmação quando o pagamento for identificado. Aproveite e veja nossa lista de parceiros.'
          redirect_to cidades_belo_horizonte_path
          return
        end
      else
        flash.now[:error] = @cliente.errors.to_a.join("\n")
      end

    elsif validate_entries { trata_se_cadastro_amigo_valido? } && @cliente.save
      resp, resposta = realiza_pagamento()

      if sucesso?(resposta)
        grava_info_amigo if session[:plano_duplo]
        # ContactMailer.delay.email(EmailCadastroEfetuado.first, @cliente)
        ContactMailer.email(EmailCadastroEfetuado.first, @cliente).deliver
        
        if(pagamento_params[:meio_pagamento] == 'debito')
            flash[:notice] = 'Dados atualizados com sucesso. Você receberá um email de confirmação quando o pagamento for identificado. Aproveite e veja nossa lista de parceiros.'
            redirect_to link_pagamento(resp)
            return
          elsif(pagamento_params[:meio_pagamento] == 'boleto')
            flash[:notice] = 'O boleto para pagamento foi enviado para o seu email. Obrigado!'
            redirect_to cidades_belo_horizonte_path
            return
          end
          
          flash[:notice] = 'Dados atualizados com sucesso. Você receberá um email de confirmação quando o pagamento for identificado. Aproveite e veja nossa lista de parceiros.'
          redirect_to cidades_belo_horizonte_path
          return
      else
        Cliente.delete(@cliente)
      end

    elsif @cliente.errors[:cpf].include? "já está cadastrado em nossa base de dados."
      cliente = Cliente.find_by_cpf @cliente.cpf
      notifica_cliente_por_email(cliente)
      flash.now[:error] = "Este CPF já está em uso. Para prosseguir com o cadastramento, acesse seu email (#{cliente.email}) e siga as intruções."
    else
      flash.now[:error] = @cliente.errors.to_a.join("\n")
    end

    @id_sessao = CheckoutController.get_id_sessao
    render :new
  end

  def new_amigo
    log = LogHashEmailAmigo.find_by_rand_hash(params[:hash])
    session[:hash] = log.rand_hash
    @cliente = Cliente.new(cpf: log.cpf, email: log.email)
  end

  def create_amigo
    log = LogHashEmailAmigo.find_by_rand_hash(session[:hash])
    contratante = log.cliente
    @cliente = Cliente.new(cliente_params)
    @cliente.plano = contratante.plano
    
    if validate_entries { verify_recaptcha(:model => @cliente, :message => "Captcha incorreto") }
      @cliente.expira_em = contratante.expira_em
      @cliente.amigo = contratante

      @cliente.save
      contratante.update({cliente_id: @cliente.id})

      log.destroy

      flash[:notice] = 'Cadastro efetuado com sucesso. Você receberá um email de confirmação quando o pagamento for identificado. Aproveite e veja nossa lista de parceiros.'
      # ContactMailer.delay.email(EmailCadastroEfetuado.first, @cliente)
      ContactMailer.email(EmailCadastroEfetuado.first, @cliente).deliver
      
      redirect_to cidades_belo_horizonte_path
      return
    else
      flash.now[:error] = @cliente.errors.to_a.join("\n")
    end

    render :new_amigo
  end

  def create_sem_pagamento # Criar sem pagamento
    @cliente = (renovacao? ? Cliente.find(session[:cliente_id]) : Cliente.new(cliente_params))
    @cliente.expira_em = Plano.find_by_codigo(session[:plano_codigo]).vigencia.days.from_now

    if renovacao? # verifica se session[:cliente_id] está setado

      if validate_entries { verify_recaptcha(:model => @cliente, :message => "Captcha incorreto") } && @cliente.update(cliente_params)
        flash[:notice] = 'Cadastro atualizado com sucesso. Aproveite e veja nossa lista de parceiros.'
        # ContactMailer.delay.email(EmailCadastroEfetuado.first, @cliente)
        ContactMailer.email(EmailCadastroEfetuado.first, @cliente).deliver
        
        redirect_to cidades_belo_horizonte_path
        return
      else
        flash.now[:error] = @cliente.errors.to_a.join("\n")
      end
    
    else

      if validate_entries { verify_recaptcha(:model => @cliente, :message => "Captcha incorreto") } && @cliente.save
        flash[:notice] = 'Cadastro efetuado com sucesso. Aproveite e veja nossa lista de parceiros.'
        # ContactMailer.delay.email(EmailCadastroEfetuado.first, @cliente)
        ContactMailer.email(EmailCadastroEfetuado.first, @cliente).deliver

        redirect_to cidades_belo_horizonte_path
        return
      elsif @cliente.errors[:cpf].include? "já está cadastrado em nossa base de dados."
        cliente = Cliente.find_by_cpf @cliente.cpf
        notifica_cliente_por_email(cliente)
        flash.now[:error] = "Este CPF já está em uso. Para prosseguir com o cadastramento, acesse seu email (#{cliente.email}) e siga as intruções."
      else
        flash.now[:error] = @cliente.errors.to_a.join("\n")
      end

    end

    render :new_sem_pagamento
  end

  def new_sem_pagamento
    @cliente = (session[:cliente_id] ? Cliente.find(session[:cliente_id]) : Cliente.new)
    session[:cupom_discount] = nil
    session[:cupom_code] = nil
  end

  def cupom
    status =
    if cupom_valido?(params[:code])
      set_sessions_params(params[:code])
      'valido'
    else
      'invalido'
    end

    respond_to do |format|
      format.json {render json: {cupom: status}}
    end
  end

  def cards_brand
    sprocket = Rails.application.assets['cards/'+params[:code].downcase+'.png']
    img_path = '/assets/' + sprocket.digest_path if sprocket

    respond_to do |format|
      format.json {render json: {path: img_path}}
    end
  end

  # PATCH/PUT /clientes/1
  # PATCH/PUT /clientes/1.json
  def update
    if @cliente.update(cliente_params_admin)
      redirect_to clientes_path, notice: 'Cliente atualizado.'
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

    def renovacao?
      true if session[:cliente_id]
    end

    def validate_entries
      valid = @cliente.valid?
      taec = termo_aceito_e_email_confirmado?
      y = yield

      return valid && taec && y
    end

    def realiza_pagamento
      parametrosPagamento = get_parametros_validos()
      retornoPagSeguro = CheckoutController.start(parametrosPagamento)
      resposta = check_response_code(retornoPagSeguro)
      return retornoPagSeguro, resposta
    end

    def notifica_cliente_por_email(cliente)
      hash = SecureRandom.urlsafe_base64 32
      # ContactMailer.delay.email_expiracao_plano(EmailCpfJaCadastrado.first, cliente, hash)
      ContactMailer.email_expiracao_plano(EmailCpfJaCadastrado.first, cliente, hash).deliver
      LogHash.create({cliente_id: cliente.id, rand_hash: hash})
    end

    def link_pagamento(resp)
      Nokogiri::XML(resp.body).xpath('//paymentLink').text
    end

    def check_response_code(resp)
      if resp.code == "400"
        return erros(resp)
      elsif resp.code =="500"
        return ["O PagSeguro não está disponível no momento e, por isso, não foi possível finalizar a solicitação de pagamento. Volte mais tarde."]
      elsif resp.code == "200"
        return ""
      else
        return ["Um erro inesperado ocorreu durante o processo de pagamento. Contate o administrador do sistema ou volte mais tarde."]
      end
    end

    def set_sessions_params(code)
      session[:cupom_code] = code
      session[:cupom_discount] = session[:plano_preco].to_f / 2
    end

    def cupom_valido?(cupom)
      CUPOM_CODE.include?(cupom.downcase)
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
        :cupom,
        :aceite,
        :plano_id,
        :cupom)
    end

    def cliente_params_admin
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
        :cupom,
        :aceite,
        :expira_em,
        :num_cartao)
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
        :meio_pagamento,
        :preco_total_parcelamento,
        :valor_parcelas,
        :num_parcelas
        )
    end

    def termo_aceito_e_email_confirmado?
      @email_confirm = params[:email_confirm]
      if params[:cliente][:aceite] == "1" && (@email_confirm.nil? || @email_confirm == params[:cliente][:email])
        return true
      else
        @cliente.errors.messages.store :aceite, ['os termos'] unless 
                params[:cliente][:aceite] == "1"
        @cliente.errors.messages.store :email_de_confirmação, ['deve ser igual ao email fornecido'] unless
                @email_confirm == params[:cliente][:email]
        return false
      end
    end

    def grava_info_amigo
      hash = SecureRandom.urlsafe_base64 32
      LogHashEmailAmigo.create({cliente_id: @cliente.id, rand_hash: hash, cpf: params[:cliente][:cpf_amigo], email: params[:cliente][:email_amigo]})
      # ContactMailer.delay.email_plano_amigo(EmailAvisoAmigo.first, params[:cliente][:email_amigo], hash)
      # yyContactMailer.email_plano_amigo(EmailAvisoAmigo.first, params[:cliente][:email_amigo], hash).deliver
    end

    def trata_se_cadastro_amigo_valido?
      if session[:plano_duplo]
        @cpf_amigo = params[:cliente][:cpf_amigo]
        @email_amigo = params[:cliente][:email_amigo]
        if @cpf_amigo == params[:cliente][:cpf]
          @cliente.errors.messages.store :cpf_do_amigo, ['deve ser diferente do seu CPF']
        end

        if @email_amigo == params[:cliente][:email]
          @cliente.errors.messages.store :email_do_amigo, ['deve ser diferente do seu email']
        end

        if @email_amigo.empty?
          @cliente.errors.messages.store :email_do_amigo, ['deve ser preenchido']
        elsif (@email_amigo =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i).nil?
          @cliente.errors.messages.store :email_do_amigo, ['inválido']
        elsif (cliente = Cliente.find_by_email(@email_amigo)) && !cliente.expirado?
            @cliente.errors.messages.store :email_do_amigo, ['já cadastrado em nossa base de dados']
        end

        if @cpf_amigo.empty?
          @cliente.errors.messages.store :cpf_do_amigo, ['deve ser preenchido']
        elsif !Cpf.new(@cpf_amigo).valido?
          @cliente.errors.messages.store :cpf_do_amigo, ['inválido']
        elsif (cliente = Cliente.find_by_cpf(@cpf_amigo)) && !cliente.expirado?
          @cliente.errors.messages.store :cpf_do_amigo, ['já cadastrado em nossa base de dados']
        end

        return false if @cliente.errors.has_key?(:email_do_amigo) || @cliente.errors.has_key?(:cpf_do_amigo)
      end

      return true
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
        flash.now[:error] = resposta.join("\n")
        return false
      else resposta.class == String # sucesso
        return true
      end
    end

    def plano_escolhido?
      plano = Plano.find_by_nome(params[:plano])

      if plano
        set_plano_session(plano)
      else
        redirect_to nossos_planos_path
      end

    end

    def hash_amigo_valido?
      redirect_to nossos_planos_path unless LogHashEmailAmigo.find_by_rand_hash(params[:hash])
    end

    def set_plano_session(plano)
      session[:plano_id] = plano.id
      session[:plano_codigo] = plano.codigo
      session[:plano_nome] = plano.nome
      session[:plano_preco] = plano.preco
      session[:plano_vigencia] = plano.vigencia
      session[:plano_duplo] = plano.duplo
    end

    def plano_params
      preco = session[:cupom_discount] || session[:plano_preco]
      return {id_plano: session[:plano_codigo], plano: session[:plano_nome], preco: preco}
    end

    def erros(resposta)
    xml = Nokogiri::XML(resposta.body)
    erros = xml.xpath('//code').map {|a| a.text}
    return mensagens_erro(erros)
  end

  def mensagens_erro(erros)
    erros.map do |erro|
      case erro.to_i
      when 53004
        "Quantidade inválida de itens. Contate o administrador do sistema."
      when 53005
        "Informe a moeda de pagamento. Contate o administrador do sistema."
      when 53006
        "Moeda inválida. Contate o administrador do sistema."
      when 53007
        "Tamanho da referência é inválido. Contate o administrador do sistema."
      when 53008
        "Tamanho da URL de notificação é inválido. Contate o administrador do sistema."
      when 53009
        "URL de notificação inválida. Contate o administrador do sistema."
      when 53010
        "Email deve ser informado."
      when 53011
        "Tamanho do email inválido."
      when 53012
        "Email fornecido não é válido."
      when 53013
        "Forneça seu nome."
      when 53014
        "Tamanho do nome inválido."
      when 53015
        "Nome inválido."
      when 53017
        "Informe um CPF válido."
      when 53018
        "Informe o DDD."
      when 53019
        "DDD inválido."
      when 53020
        "Informe o telefone."
      when 53021
        "Telefone inválido."
      when 53022
        "Informe o CEP."
      when 53023
        "CEP inválido."
      when 53024
        "Informe a rua."
      when 53025
        "Tamanho do nome da rua inválido."
      when 53026
        "Informe o número da casa/apartamento."
      when 53027
        "Tamanho do número da casa é inválido."
      when 53028
        "Tamanho do complemento é inválido."
      when 53029
        "Informe o bairro."
      when 53030
        "Tamanho do nome do bairo é inválido."
      when 53031
        "Informe uma cidade."
      when 53032
        "Tamanho do nome da cidade é inválido."
      when 53033
        "Informe um estado."
      when 53034
        "Estado informado inválido."
      when 53035
        "É necessário informar o país. Contate o administrador do sistema."
      when 53036
        "Tamanho do nome do país é inválido. Contate o administrador do sistema."
      when 53037
        "Cartão inválido. Verifique se o número, o CVV e a validade do cartão estão corretas."
      when 53038
        "Informe o número de parcelas."
      when 53039
        "Número de parcelas inválido."
      when 53040
        "O valor das parcelas deve ser informado."
      when 53041
        "Valor das parcelas inválido."
      when 53042
        "Informe o nome impresso no cartão."
      when 53043
        "Tamanho do nome impresso no cartão inválido."
      when 53044
        "Nome impresso no cartão é inválido."
      when 53045
        "Informe o CPF do dono do cartão de crédito."
      when 53046
        "CPF do dono do cartão de crédito inválido."
      when 53047
        "Informe a data de nascimento do dono do cartão de crédito."
      when 53048
        "Data de nascimento inválida."
      when 53049
        "Informe o DDD do telefone do dono do cartão de crédito."
      when 53050
        "DDD do dono do cartão de crédito inválido."
      when 53051
        "Informe o telefone do dono do cartão de crédito."
      when 53052
        "Telefone do dono do cartão de crédito inválido."
      when 53053
        "Informe o CEP do dono do cartão de crédito."
      when 53054
        "CEP do dono do cartão de crédito inválido."
      when 53055
        "Informe a rua do dono do cartão de crédito."
      when 53056
        "Tamanho do nome da rua do dono do cartão de crédito é inválido."
      when 53057
        "Informe o número da casa/apartamento do dono do cartão de crédito."
      when 53058
        "Tamanho do número da casa do dono do cartão de crédito é inválido."
      when 53059
        "Tamanho do complemento do dono do cartão de crédito é inválido."
      when 53060
        "Informe o bairro do dono do cartão de crédito."
      when 53061
        "Tamanho do nome do bairro do dono do cartão de crédito é inválido."
      when 53062
        "Informe a cidade do dono do cartão de crédito."
      when 53063
        "Tamanho do nome da cidade inválido."
      when 53064
        "Informe o estado do dono do cartão de crédito."
      when 53065
        "Estado informado inválido."
      when 53066
        "País do dono do cartão de crédito deve ser informado. Contate o administrador do sistema."
      when 53067
        "Tamanho do nome do país inválido. Contate o administrador do sistema."
      when 53068
        "Tamanho do email do destinatário é inválido. Contate o administrador do sistema."
      when 53069
        "Email do destinatário inválido. Contate o administrador do sistema."
      when 53070
        "ID do item deve ser informado. Contate o administrador do sistema."
      when 53071
        "Tamanho do ID do item inválido. Contate o administrador do sistema."
      when 53072
        "Descrição do item deve ser informado. Contate o administrador do sistema."
      when 53073
        "Tamanho do nome do item inválido. Contate o administrador do sistema."
      when 53074
        "Quantidade de itens deve ser informada. Contate o administrador do sistema."
      when 53075
        "Quantidade de itens inválida. Contate o administrador do sistema."
      when 53076
        "Quantidade itens inválida. Contate o administrador do sistema."
      when 53077
        "Preço do item deve ser informada. Contate o administrador do sistema."
      when 53078
        "Preço do item deve ter 2 casas decimais. Contate o administrador do sistema"
      when 53079
        "Preço do item inválido. Contate o administrador do sistema."
      when 53081
        "Comprador está relacionado com o vendedor. Contate o administrador do sistema."
      when 53084
        "Destinatário inválido. Contate o administrador do sistema."
      when 53085
        "Método de pagamento indisponível."
      when 53086
        "Preço total inválido. Contate o administrador do sistema."
      when 53087
        "Dados do cartão de crédito inválidos."
      when 53091
        "Identificador do vendedor inválido. Contate o administrador do sistema."
      when 53092
        "Bandeira do cartão não é aceita."
      when 53098
        "Total da compra é negativo. Contate o administrador do sistema."
      when 53099
        "Valor dos encargos é inválido. Contate o administrador do sistema."
      when 53101
        "Modo de pagamento inválido. Contate o administrador do sistema."
      when 53102 
        "Meio de pagamento inválido. Os valores aceitos são: creditCard, boleto e etf. Contate o administrador do sistema."
      when 53105
        "Informe o email."
      when 53106
        "Nome do dono do cartão de crédito está incompleto."
      when 53110
        "Informe o banco para débito online."
      when 53111
        "Banco informado não é aceito"
      when 53115
        "Data de nascimento inválida."
      when 53140
        "Número de parcelas inválida."
      when 53141
        "Mensagem do PagSeguro: você está bloqueado."
      when 53142
        "Token do cartão de crédito inválido."
      end
    end
  end
end
