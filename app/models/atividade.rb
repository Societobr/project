class Atividade < ActiveRecord::Base
	belongs_to :cliente
	belongs_to :user

	validates_presence_of :cliente_id,
		:message => 'deve ser informado'
	validates_presence_of :preco_total,
		:message => 'deve ser informado'
	validates_presence_of :valor_desconto,
		:message => 'deve ser informado'
end
