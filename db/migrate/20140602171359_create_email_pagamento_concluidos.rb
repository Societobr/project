class CreateEmailPagamentoConcluidos < ActiveRecord::Migration
  def change
    create_table :email_pagamento_concluidos do |t|
      t.string :assunto
      t.string :body

      t.timestamps
    end
  end
end
