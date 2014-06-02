class ContatosController < ApplicationController

  before_filter :authorize, except: [:new, :create]
  layout 'dashboard', except: [:new, :create]

  # renderiza página de contato
	def new
    @contato = Contato.new
  end

  # envia informações da página de contato
  # para email cadastrado.
  def create
    @contato = Contato.new(contato_params)

    if @contato.valid?
      ContactMailer.mensagem_contato(@contato).deliver
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
    if @email.update(email_cadastro_params)
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
    if @email.update(email_pagamento_params)
      flash.now[:notice] = "Dados gravados com sucesso."
    else
      flash.now[:error] = @email.errors.to_a.join("\n")
    end
    render :edit_email_pagamento_recebido
  end

  # envia email de expiração de plano
  def self.send_email_expiracao
    email = EmailExpiracaoPlano.first
    clientes = Cliente.where({ expira_em: Date.today..Date.today+email.antec_envio })
    unless clientes.empty?
      clientes.each do |cliente|
        ContactMailer.email(email, cliente).deliver
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contato_params
      params.require(:contato).permit(:nome, :email, :assunto, :mensagem)
    end

    def email_params
      params.require(:email_expiracao_plano).permit(:assunto, :body, :antec_envio, :recorrencia)
    end

    def email_cadastro_params
      params.require(:email_cadastro_efetuado).permit(:assunto, :body)
    end

    def email_pagamento_params
      params.require(:email_pagamento_recebido).permit(:assunto, :body)
    end

end