class ContactMailer < ActionMailer::Base
  default :from => ENV["GMAIL_USERNAME"]

  def mensagem_contato(contato)
    @contato = contato
    mail(:to => ENV["GMAIL_USERNAME"], :subject => contato.assunto)
  end

  def mensagem_expiracao(email, cliente)
    @email = email
		mail(to: cliente.email, subject: email.assunto)
  end
end