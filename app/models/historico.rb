class Historico < ActiveRecord::Base
	belongs_to :cliente
	belongs_to :status_transacao_pag_seguro

	belongs_to :plano
end
