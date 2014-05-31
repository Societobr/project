class ContatosController < ApplicationController

  before_filter :authorize, except: [:new, :create]
  layout 'dashboard', only: :new_email_expiracao

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
      flash[:success] = 'Sua mensagem foi recebida com sucesso. Obrigado!'
  	else
  		flash[:error] = "<strong>Não foi possível enviar sua mensagem.</strong>\n" + @contato.errors.to_a.join("\n")
    end
    render :action => 'new'
  end

  # renderiza página para definição do email
  # de alerta sobre expiração do plano
  def new_email_expiracao
    @email = EmailExpiracaoPlano.new
  end

  # grava os dados do email a ser enviado
  # quando expiração estiver próxima.
  def create_email_expiracao
    @email = EmailExpiracaoPlano.new(email_params)
    if @email.save?
      EmailExpiracaoPlano.first.delete # deleta a versão antiga
      flash[:succes] = "Dados gravados com sucesso."
    else
      flash[:error] = @email.errors.to_a.join("\n")
    end
    render :new_email_expiracao
  end

  # envia email de expiração de plano
  def self.send_email_expiracao
    email = EmailExpiracaoPlano.first
    clientes = Cliente.where({ expira_em: Date.today..Date.today+email.antec_envio })
    unless clientes.empty?
      clientes.each do |cliente|
        ContactMailer.mensagem_expiracao(email, cliente).deliver
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contato_params
      params.require(:contato).permit(:nome, :email, :assunto, :mensagem)
    end

    def email_params
      params.require(:email).permit(:assunto, :body, :antec_envio, :recorrencia)
    end
end