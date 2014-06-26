class ContatosController < ApplicationController

  before_filter :authorize_admin, except: [:new, :create]
  layout 'dashboard/dashboard', except: [:new, :create]

  # renderiza página de contato
	def new
    @contato = Contato.new
  end

  # envia informações da página de contato
  # para email cadastrado.
  def create
    @contato = Contato.new(contato_params)

    if @contato.valid?
      ContactMailer.delay.mensagem_contato(@contato) # Uses sidekiq
      flash.now[:success] = 'Sua mensagem foi recebida com sucesso. Obrigado!'
  	else
  		flash.now[:error] = "<strong>Não foi possível enviar sua mensagem.</strong>\n" + @contato.errors.to_a.join("\n")
    end

    render :action => 'new'
  end

  # renderiza página para definição do email
  # de alerta sobre expiração do plano
  def edit_email_expiracao
    @email = EmailExpiracaoPlano.first
  end

  # grava os dados do email a ser enviado
  # quando expiração estiver próxima.
  def update_email_expiracao
    @email = EmailExpiracaoPlano.first
    if @email.update(email_params)
      flash.now[:notice] = "Dados gravados com sucesso."
    else
      flash.now[:error] = @email.errors.to_a.join("\n")
    end
    render :edit_email_expiracao
  end

  def edit_email_cadastro_efetuado
    @email = EmailCadastroEfetuado.first
  end

  def update_email_cadastro_efetuado
    @email = EmailCadastroEfetuado.first
    if @email.update(email_params(:email_cadastro_efetuado))
      flash.now[:notice] = "Dados gravados com sucesso."
    else
      flash.now[:error] = @email.errors.to_a.join("\n")
    end
    render :edit_email_cadastro_efetuado
  end

  def edit_email_pagamento_recebido
    @email = EmailPagamentoRecebido.first
  end

  def update_email_pagamento_recebido
    @email = EmailPagamentoRecebido.first
    if @email.update(email_params(:email_pagamento_recebido))
      flash.now[:notice] = "Dados gravados com sucesso."
    else
      flash.now[:error] = @email.errors.to_a.join("\n")
    end
    render :edit_email_pagamento_recebido
  end

  def edit_email_aviso_amigo
    @email = EmailAvisoAmigo.first
  end

  def update_email_aviso_amigo
    @email = EmailAvisoAmigo.first
    if @email.update(email_params(:email_aviso_amigo))
      flash.now[:notice] = "Dados gravados com sucesso."
    else
      flash.now[:error] = @email.errors.to_a.join("\n")
    end
    render :edit_email_aviso_amigo
  end

  def edit_email_cpf_ja_cadastrado
    @email = EmailCpfJaCadastrado.first
  end

  def update_email_cpf_ja_cadastrado
    @email = EmailCpfJaCadastrado.first
    if @email.update(email_params(:email_cpf_ja_cadastrado))
      flash.now[:notice] = "Dados gravados com sucesso."
    else
      flash.now[:error] = @email.errors.to_a.join("\n")
    end
    render :edit_email_cpf_ja_cadastrado
  end

  # envia email de expiração de plano
  def self.send_email_expiracao
    email = EmailExpiracaoPlano.first
    diaExpiracao = email.antec_envio.days.from_now.to_date
    clientes = clientes_expirando(diaExpiracao, email.recorrencia)
    
    unless clientes.empty?      
      clientes.to_hash.each do |clt|
        cliente = Cliente.new(clt)
        hash = SecureRandom.urlsafe_base64 32
        log_email_expiracao(cliente, hash)
        ContactMailer.delay.email_expiracao_plano(email, cliente, hash) # Uses sidekiq
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contato_params
      params.require(:contato).permit(:nome, :email, :assunto, :mensagem)
    end

    def email_params(obj=nil)
      if obj
        params.require(obj).permit(:assunto, :body)
      else
        params.require(:email_expiracao_plano).permit(:assunto, :body, :antec_envio, :recorrencia)
      end
    end

    def self.log_email_expiracao(cliente, hash)
      lee = LogEmailExpiracao.find_or_initialize_by(cliente_id: cliente.id)
      lee.id? ? lee.touch : lee.save
      LogHashEmailExpiracao.create({cliente_id: cliente.id, rand_hash: hash})
    end

    def self.clientes_expirando(dataLimite, recorrencia)
      query = "SELECT * FROM clientes WHERE (clientes.expira_em BETWEEN '#{Date.current}' AND '#{dataLimite}') AND clientes.id NOT IN \
      (SELECT clientes.id FROM clientes LEFT JOIN log_email_expiracaos ON log_email_expiracaos.cliente_id = clientes.id \
      WHERE log_email_expiracaos.updated_at > '#{recorrencia.days.ago.to_date}')"
      
      return ActiveRecord::Base.connection.exec_query(query)
    end

end