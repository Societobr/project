class CreateEmailAvisoAmigos < ActiveRecord::Migration
  def change
    create_table :email_aviso_amigos do |t|
      t.string :assunto
      t.string :body

      t.timestamps
    end
  end
end
