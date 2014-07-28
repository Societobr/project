# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([
	{username: 'admin', password: '123456', role_id: 1}
	])
Role.create([
	{description: 'ADMIN'},
	{description: 'PARCEIRO'},
	])
EmailPagamentoRecusado.create([
	{assunto: 'Seu pagamento foi recusado/cancelado',
	body:'<h2>Seu pagamento foi recusado/cancelado.<h2>.',}
	])
EmailExpiracaoPlano.create([
	{assunto: 'Renove seu plano.',
	body: '<h2>Seu plano expira em alguns dias.<h2> <br /> Faça a renovação e continue a aproveitando as vantagens que só o societo lhe proporciona.',
	antec_envio: 30,
	recorrencia: 1}
	])
EmailAvisoAmigo.create({
	assunto: 'Resgate seu presente!',
	body: '<h2>Seu email foi cadastrado no plano Amigo do Societo.<h2> <br /> Acesse o link abaixo e efetue seu cadastro.'
	})
EmailPagamentoRecebido.create([
	{assunto: 'Seu pagamento foi identificado',
	body: '<h2>Recebemos seu pagamento e ativos sua conta.<h2> <br /> A partir de agora você já conta com todas as vantagens que só o societo lhe proporciona.'}
	])
EmailCpfJaCadastrado.create([
	{assunto: 'Reative sua conta',
	body: 'Para dar prosseguimento ao cadastro, <ol> <li> clique no link abaixo </li> <li> Escolha um novo plano </li> <li> Atualize seus dados </li> <li> Efetue o pagamento </li> </ol>'}
	])
EmailCadastroEfetuado.create([
	{assunto: 'Bem vindo ao Societo!',
	body: '<h2>Seu cadastro foi efetuado com sucesso!<h2> <br /> Assim que seu pagamento for identificado, ativaremos sua conta!!!'}
	])
Plano.create([
	{nome: 'MENSAL',
		vigencia: 30,
		preco: 1.00,
		codigo: 'M1',
		duplo: false
		},
	{nome: 'ANUAL',
		vigencia: 60,
		preco: 1.01,
		codigo: 'A2',
		duplo: false
		},
	{nome: 'AMIGO',
		vigencia: 90,
		preco: 1.02,
		codigo: 'A3',
		duplo: true
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