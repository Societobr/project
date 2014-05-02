class Contato
	# Faz com que classe se comporte como uma ActiveRecord, mas não persiste dados no banco
	include ActiveAttr::Model

	attribute :nome
	attribute :email
	attribute :assunto
	attribute :mensagem

	validates :nome,
            :length => {:in => 2..50, :message => 'deve ter pelo menos 2 letras.'}

  	validates :email,
            :format => { :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
            			:multiline => true,
            			:message => 'com formato incorreto ou não fornecido.' }

  	validates_presence_of :mensagem, :message => 'deve ser informada.'
end