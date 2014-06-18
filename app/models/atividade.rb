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

	def self.relat_do_parc(atividades)
  	  columns = %w{ DATA CLIENTE TOTAL DESCONTO PAGO }
  	  total = 0
  	  descontos = 0

  	  CSV.generate do |csv|
        csv << columns
  	    
  	    atividades.each do |atividade|
    	  total += atividade.preco_total
    	  descontos += atividade.valor_desconto
    	  
  		  csv << [atividade.created_at.to_s_br,
  		  			atividade.cliente.nome,
  		  			atividade.preco_total,
  		  			atividade.valor_desconto,
  		  			(atividade.preco_total - atividade.valor_desconto)]
  		end

  		csv << ['RESUMO', nil, total, descontos, (total - descontos)]
  	  end
  	end

  	def self.relat_do_admin(atividades)
  	  columns = %w{ TOTAL DESCONTO PAGO }
  	  total = 0
  	  descontos = 0

  	  atividades.each do |atividade|
  	  	total += atividade.preco_total
  	  	descontos += atividade.valor_desconto
  	  end

	  CSV.generate do |csv|
        csv << columns
  	    csv << [total, descontos, (total - descontos)]
	  end
  	end

end
