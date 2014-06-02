class Cliente < ActiveRecord::Base
	has_many :atividades
	has_many :users, through: :atividades
	has_many :historicos
	has_many :status_transacao_pag_seguros, through: :historicos
	
	after_save :set_registro
	scope :expirados, where('expira_em < ?', Date.today)

	message = 'deve ser preenchido'

	usar_como_cpf :cpf
	#validate :cpf_unico
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

	def cpf_unico
	    if self.cpf and !self.cpf.to_s.empty? and Cliente.where(cpf: self.cpf).where('id <> ?', self.id || 0).first
	      errors.add(:cpf, "já está sendo usado")
	    end
	end

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
