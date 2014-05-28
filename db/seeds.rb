# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([
	{username: 'admin', password: '123456'},
	{username: 'parceiro', password: '123456'},
	{username: 'parceiro1', password: '123456'},
	])
Atividade.create([
	{user_id: 2, cliente_id: 1, preco_total: 200.20, valor_desconto: 20.02},
	{user_id: 3, cliente_id: 1, preco_total: 300.30, valor_desconto: 30.03},
	{user_id: 2, cliente_id: 2, preco_total: 500.50, valor_desconto: 50.05},
	{user_id: 3, cliente_id: 3, preco_total: 600.60, valor_desconto: 60.06},
	])
Cliente.create([
	{nome: 'Nome1 de Sobrenome1',
		email: 'a@a.com',
		cpf: '863.113.453-82',
		nascimento: '1900/01/01',
		ddd: '11',
		telefone: '1111-1111',
		cep: '11.111-111',
		estado: 'AC',
		rua: 'Rua 1',
		numero: 'Numero 1',
		complemento: 'Complemento1',
		bairro: 'Bairro1',
		cidade: 'Cidade1'},
	{nome: 'Nome2 de Sobrenome2',
		email: 'b@b.com',
		cpf: '863.113.453-82',
		nascimento: '1900/02/02',
		ddd: '22',
		telefone: '2222-2222',
		cep: '22.222-222',
		estado: 'AM',
		rua: 'Rua 2',
		numero: 'Numero 2',
		complemento: 'Complemento2',
		bairro: 'Bairro2',
		cidade: 'Cidade2'}
	])
StatusTransacaoPagSeguro.create([
	{code: 1, description: 'Aguardando pagamento'},
	{code: 2, description: 'Em análise'},
	{code: 3, description: 'Paga'},
	{code: 4, description: 'Disponível'},
	{code: 5, description: 'Em disputa'},
	{code: 6, description: 'Devolvida'},
	{code: 7, description: 'Cancelada'},
	])