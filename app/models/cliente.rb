class Cliente < ActiveRecord::Base
	has_many :atividades
	has_many :users, through: :atividades

	after_save :set_registro

	message = 'deve ser preenchido'

	usar_como_cpf :cpf
	validates_presence_of :nome, :message => message
	validates_presence_of :sobrenome, :message => message
	validates_presence_of :email, :message => message
	validates_presence_of :cpf, :message => message
	validates_presence_of :nascimento, :message => message
	validates_presence_of :telefone, :message => message
	validates_presence_of :cep, :message => message
	validates_presence_of :estado, :message => message
	validates_exclusion_of :estado, :in => %w( Estado ), :message => message
	validates_presence_of :cidade, :message => message
	validates_presence_of :endereco, :message => message

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
