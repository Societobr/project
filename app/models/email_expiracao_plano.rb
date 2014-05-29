class EmailExpiracaoPlano < ActiveRecord::Base
	validates_presence_of :assunto,
		:body,
		:antec_envio, message: "Informe todos os campos."
end