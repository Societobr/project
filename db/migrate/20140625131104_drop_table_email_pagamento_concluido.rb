class DropTableEmailPagamentoConcluido < ActiveRecord::Migration
  def change
  	drop_table :email_pagamento_concluidos
  end
end
