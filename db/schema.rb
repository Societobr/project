# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140602173502) do

  create_table "atividades", force: true do |t|
    t.integer  "user_id"
    t.integer  "cliente_id"
    t.decimal  "preco_total",    precision: 10, scale: 0
    t.decimal  "valor_desconto", precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "atividades", ["cliente_id"], name: "index_atividades_on_cliente_id", using: :btree
  add_index "atividades", ["user_id"], name: "index_atividades_on_user_id", using: :btree

  create_table "clientes", force: true do |t|
    t.string   "nome"
    t.string   "email"
    t.string   "cpf"
    t.date     "nascimento"
    t.string   "telefone"
    t.string   "cep"
    t.string   "estado"
    t.string   "cidade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "registro"
    t.date     "expira_em"
    t.string   "ddd"
    t.string   "bairro"
    t.string   "complemento"
    t.string   "numero"
    t.string   "rua"
    t.string   "cupom"
    t.boolean  "aceite"
  end

  create_table "email_cadastro_efetuados", force: true do |t|
    t.string   "assunto"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_expiracao_planos", force: true do |t|
    t.string  "assunto"
    t.integer "antec_envio"
    t.text    "body"
    t.integer "recorrencia"
  end

  create_table "email_pagamento_concluidos", force: true do |t|
    t.string   "assunto"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_pagamento_recebidos", force: true do |t|
    t.string   "assunto"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "historicos", force: true do |t|
    t.integer  "cliente_id"
    t.integer  "status_transacao_pag_seguro_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor",                          precision: 10, scale: 0
    t.integer  "plano_id"
    t.date     "vigencia"
  end

  add_index "historicos", ["cliente_id"], name: "index_historicos_on_cliente_id", using: :btree
  add_index "historicos", ["plano_id"], name: "index_historicos_on_plano_id", using: :btree
  add_index "historicos", ["status_transacao_pag_seguro_id"], name: "index_historicos_on_status_transacao_pag_seguro_id", using: :btree

  create_table "planos", force: true do |t|
    t.string   "nome"
    t.integer  "vigencia"
    t.decimal  "preco",      precision: 10, scale: 0
    t.string   "codigo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "status_transacao_pag_seguros", force: true do |t|
    t.integer  "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
