class CreateEmailPagamentoRecusados < ActiveRecord::Migration
  def change
    create_table :email_pagamento_recusados do |t|
      t.string :assunto
      t.string :body

      t.timestamps
    end
  end
end
