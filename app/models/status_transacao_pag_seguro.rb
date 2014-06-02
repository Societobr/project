class StatusTransacaoPagSeguro < ActiveRecord::Base
	has_many :historicos
	has_many :clientes, through: :historicos
end
