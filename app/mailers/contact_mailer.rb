class ContactMailer < ActionMailer::Base
  default :from => ENV["GMAIL_USERNAME"]

  def mensagem_contato(contato)
    @contato = contato
    mail(:to => ENV["GMAIL_USERNAME"], :subject => contato.assunto)
  end

  def email(email, cliente)
    @email = email
	  mail(to: cliente.email, subject: email.assunto)
  end

  def email_expiracao_plano(email, cliente, hash)
  	@hash = hash
  	@email = email
	  mail(to: cliente.email, subject: email.assunto)
  end

  def email_pagamento_recusado(email, cliente, hash)
    @hash = hash
    @email = email
    mail(to: cliente.email, subject: email.assunto)
  end

  def email_plano_amigo(email, email_cliente, hash)
    @hash = hash
    @email = email
    mail(to: email_cliente, subject: email.assunto)
  end
end