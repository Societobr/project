class EmailCadastroEfetuado < ActiveRecord::Base
	validates_presence_of :assunto,
		:body, message: "Informe todos os campos."
end
