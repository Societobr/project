class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])

    if transaction.errors.empty?
      trata_resposta(transaction)
    end

    render nothing: true, status: 200
  end

  private

  def trata_resposta(trans)
    update_status_cliete(trans.status.id, trans.reference, trans.items.first.id, trans.gross_amount)
  end

  def update_status_cliete(status, cliente_id, plano_codigo, valPago)
    cliente = Cliente.find_by_registro(cliente_id)
    plano = Plano.find_by_codigo(plano_codigo)

    case status
      # Para os casos abaixo, nada será feito (referência:
      # http://bit.ly/T41dHl em 'Status da Transação')
      # '1 - Aguardando pagamento'
      # '2 - Em análise'
      # '4 - Disponível'
      # '5 - Em disputa'
    when '1', '2', '4', '5' 
      # não faz nada
    when '3' # 'Paga'
      update_status(cliente, plano) { get_data_expiracao(cliente, plano) }
      # ContactMailer.delay.email(EmailPagamentoRecebido.first, cliente)
      ContactMailer.email(EmailPagamentoRecebido.first, cliente).deliver
    when '6' # 'Devolvida'
      update(cliente, plano) { 1.day.ago }
      valPago = -valPago.to_f
    when '7' # 'Cancelada'
      update(expira_em, cliente, plano) { 1.day.ago }
      notifica_cliente(cliente_id)
      valPago = 0
    end

    if ['3', '6', '7'].include? status
      Historico.create(
        {cliente_id: cliente.id,
          status_transacao_pag_seguro_id: status,
          valor: valPago,
          plano_id: plano.id})
    end
  end

  def update_status(cliente, plano)
    dataExpiracao = yield
    cliente.update(expira_em: dataExpiracao)
    cliente.amigo.update(expira_em: dataExpiracao) if cliente.amigo && plano.duplo
  end

  def get_data_expiracao(cliente, plano)
    if cliente.expira_em                        # É/foi cliente
      if cliente.expira_em >= Date.current      # É cliente - Renovando antes do vencimento
        cliente.expira_em + plano.vigencia.days
      else                                      # Foi cliente - Renovando após vencimento
        plano.vigencia.days.from_now
      end
    else                                        # Nunca foi cliente
      plano.vigencia.days.from_now
    end
  end

  def notifica_cliente(cliente_id)
    hash = SecureRandom.urlsafe_base64 32
    LogHash.create({cliente_id: cliente_id, rand_hash: hash})
    # ContactMailer.delay.email_pagamento_recusado(EmailPagamentoRecusado.first, cliente, hash)
    ContactMailer.email_pagamento_recusado(EmailPagamentoRecusado.first, cliente, hash).deliver
  end

end