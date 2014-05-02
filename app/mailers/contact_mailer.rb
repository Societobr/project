class ContactMailer < ActionMailer::Base
  default :from => 'cristiano.souza.mendonca@gmail.com'

  def mensagem_contato(contato)
    @contato = contato
    mail(:to => 'cristiano.souza.mendonca@gmail.com', :subject => contato.assunto)
  end
end