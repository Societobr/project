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

ActiveRecord::Schema.define(version: 20140518174934) do

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
    t.string   "sobrenome"
    t.string   "email"
    t.string   "cpf"
    t.date     "nascimento"
    t.string   "telefone"
    t.string   "cep"
    t.string   "estado"
    t.string   "cidade"
    t.string   "endereco"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "registro"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
