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
	])
EmailExpiracaoPlano.create([
	{assunto: 'Renove seu plano.',
	antec_envio: 30,
	body: '<h2>Seu plano expira em alguns dias.<h2> <br /> Faça a renovação e continue a aproveitando as vantagens que só o societo lhe proporciona.'}
	])
EmailPagamentoRecebido.create([
	{assunto: 'Se pagamento foi identificado',
	body: '<h2>Recebemos seu pagamento e ativos sua conta.<h2> <br /> A partir de agora você já conta com todas as vantagens que só o societo lhe proporciona.'}
	])
EmailCadastroEfetuado.create([
	{assunto: 'Bem vindo ao Societo!',
	body: '<h2>Seu cadastro foi efetuado com sucesso!<h2> <br /> Assim que seu pagamento for identificado, ativaremos sua conta!!!'}
	])
Plano.create([
	{nome: 'MENSAL',
		vigencia: 30,
		preco: 50.00,
		codigo: 'M1'
		},
	{nome: 'ANUAL',
		vigencia: 60,
		preco: 100.00,
		codigo: 'A2'
		},
	{nome: 'AMIGO',
		vigencia: 90,
		preco: 150.00,
		codigo: 'A3'
		},
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