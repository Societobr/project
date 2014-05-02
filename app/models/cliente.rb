class Cliente < ActiveRecord::Base
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
end
