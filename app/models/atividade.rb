class Atividade < ActiveRecord::Base
	belongs_to :cliente
	belongs_to :user

	validates_presence_of :cliente_id,
		:preco_total,
		:valor_desconto, :message => 'deve ser informado'

	validates :preco_total,
		:valor_desconto, :numericality => {:greater_than => 0, :message => "deve ser maior que 0,00"}

	validate :preco_maior_que_desconto

	def preco_maior_que_desconto
		errors.add(:base, "Preço deve ser maior que desconto") unless self.preco_total > self.valor_desconto
	end
end
