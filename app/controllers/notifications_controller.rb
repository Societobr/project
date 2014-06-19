class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    # transaction = PagSeguro::Transaction.find_by_code(params[:notificationCode])

    # if transaction.errors.empty?
    #   # Processa a notificação. A melhor maneira de se fazer isso é realizar
    #   # o processamento em background. Uma boa alternativa para isso é a
    #   # biblioteca Sidekiq.
    # end

    # render nothing: true, status: 200

    # url = "https://ws.sandbox.pagseguro.uol.com.br/v2/transactions/notifications/#{params[:notificationCode]}?email=EMAIL&token=TOKEN"
    url = "https://ws.pagseguro.uol.com.br/v2/transactions/notifications/#{params[:notificationCode]}?email=EMAIL&token=TOKEN"
    url.gsub!(/EMAIL/, ENV["EMAIL_PAGSEGURO"]).gsub!(/TOKEN/, ENV["TOKEN_PAGSEGURO"])

    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    # req['Access-Control-Allow-Origin'] = 'https://sandbox.pagseguro.uol.com.br'
    
    resp = Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    trata_resposta(resp)

    render nothing: true, status: 200
  end

  private

  def trata_resposta(resp)
    xml = Nokogiri::XML(resp.body)
    numRegCliente = xml.xpath('//transaction/reference').text
    cliente = Cliente.find_by_registro(numRegCliente)
    codPlanClient = xml.xpath('//transaction/items/item/id').text
    valPago = xml.xpath('//transaction/grossAmount').text
    statusTransPagSeg = xml.xpath('//transaction/status').text
    update_status_cliete(statusTransPagSeg, cliente, codPlanClient, valPago)
  end

  def update_status_cliete(status, cliente, codPlan, valPago)
    plano = Plano.find_by_codigo(codPlan)

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
      ContactMailer.email(EmailPagamentoRecebido.first, cliente).deliver
    when '6' # 'Devolvida'
      update(cliente, plano) { 1.day.ago }
      valPago = -valPago.to_f
    when '7' # 'Cancelada'
      update(expira_em, cliente, plano) { 1.day.ago }
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

end