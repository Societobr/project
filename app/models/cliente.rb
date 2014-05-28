class Cliente < ActiveRecord::Base
	has_many :atividades
	has_many :users, through: :atividades
	after_save :set_registro

	message = 'deve ser preenchido'

	validates_presence_of :nome,
	:ddd,
	:telefone,
	:email,
	:cpf,
	:nascimento,
	:cep,
	:cidade,
	:estado,
	:bairro,
	:rua,
	:numero, message: message

	def self.to_csv
		CSV.generate do |csv|
			csv << column_names
			all.each do |cliente|
				csv << cliente.attributes.values_at(*column_names)
			end
		end
	end

	def set_registro
		self.registro = '#' + self.created_at.strftime("%d%m%y") + self.id.to_s.rjust(4,"0")
		self.update_column(:registro, self.registro)
	end

end
