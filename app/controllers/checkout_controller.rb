class CheckoutController
  protected

  def self.start(params)
    url = "https://ws.sandbox.pagseguro.uol.com.br/v2/transactions"
    postParams = post_params(params)
    uri = URI(url)
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(postParams)
    
    resp = Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    if resp.code == "400"
      return self.erros(resp)
    elsif resp.code =="500"
      return ["O PagSeguro não está disponível no momento e, por isso, não foi possível finalizar a solicitação de pagamento. Volte mais tarde."]
    elsif resp.code == "200"
      return ""
    else
      return ["Um erro inesperado ocorreu durante o processo de pagamento. Contate o administrador do sistema ou volte mais tarde."]
    end
  end

  def self.post_params(params)
    default = get_default_parameters(params)

    case params[:meio_pagamento]
    when 'cartao' then credit_card_checkout(params, default)
    when 'boleto' then boleto_checkout(params, default)
    when 'debito' then debito_online_checkout(params, default)
    end
  end

  def self.get_default_parameters(params)
    {"email" => ENV["EMAIL_PAGSEGURO"],
      "token" => ENV["TOKEN_PAGSEGURO"],
      "paymentMode" => "default",
      "currency" => "BRL",
      "itemId1" => params[:id_plano],
      "itemDescription1" => params[:plano],
      "itemAmount1" => params[:preco],
      "itemQuantity1" => 1,
      "reference" => params[:reference],
      "senderEmail" => "c50451335031919206442@sandbox.pagseguro.com.br", #colocar email do cliente aqui
      "senderName" => params[:nome],
      "senderCPF" => params[:cpf].gsub(/\.|-/, ''),
      "senderAreaCode" => params[:ddd],
      "senderPhone" => params[:telefone].gsub(/-/, ''),
      "senderHash" => params[:identificador_vendedor],
      "shippingAddressCountry" => "BRA",
      "shippingAddressState" => params[:estado],
      "shippingAddressCity" => params[:cidade],
      "shippingAddressPostalCode" => params[:cep].gsub(/\.|-/, ''),
      "shippingAddressDistrict" => params[:bairro],
      "shippingAddressStreet" => params[:rua],
      "shippingAddressNumber" => params[:numero]}
  end

  def self.credit_card_checkout(params, default)
    default.merge({
      "paymentMethod" => "creditCard",
      "creditCardToken" => params[:tokenIdentificadorCartao],
      "installmentQuantity" => params[:parcelas],
      "installmentValue" => '%.2f'%(params[:preco] / params[:parcelas].to_i),
      "creditCardHolderName" => params[:nome_cartao],
      "creditCardHolderBirthDate" => params[:nascimento_cartao],
      "creditCardHolderCPF" => params[:cpf_cartao].gsub(/\.|-/, ''),
      "creditCardHolderAreaCode" => params[:ddd_cartao],
      "creditCardHolderPhone" => params[:telefone_cartao].gsub(/-/, ''),
      "billingAddressPostalCode" => params[:cep_cartao].gsub(/\.|-/, ''),
      "billingAddressStreet" => params[:rua_cartao],
      "billingAddressNumber" => params[:numero_endereco_cartao],
      "billingAddressDistrict" => params[:bairro_cartao],
      "billingAddressCity" => params[:cidade_cartao],
      "billingAddressState" => params[:estado_cartao],
      "billingAddressCountry" => "BRA"
    })
  end

  def self.boleto_checkout(params, default)
    default.merge({
      "paymentMethod" => "boleto"
    })
  end

  def self.debito_online_checkout(params, default)
    default.merge({
      "paymentMethod" => "eft",
      "bankName" => params[:banco]
    })
  end

  def self.get_id_sessao
    urlAutenticacao =
      "https://ws.sandbox.pagseguro.uol.com.br/v2/sessions?email=EMAIL&token=TOKEN"
    urlAutenticacao.gsub!(
      /EMAIL|TOKEN/,
      {"EMAIL" => ENV["EMAIL_PAGSEGURO"], "TOKEN" => ENV["TOKEN_PAGSEGURO"]})
    uri = URI(urlAutenticacao)
    req = Net::HTTP::Post.new(uri)
    
    resp = Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    return Nokogiri::XML(resp.body).xpath('//id').text
  end

  def self.erros(resposta)
    xml = Nokogiri::XML(resposta.body)
    erros = xml.xpath('//code').map {|a| a.text}
    return mensagens_erro(erros)
  end

  def self.mensagens_erro(erros)
    erros.map do |erro|
      case erro.to_i
      when 53004
        "Quantidade inválida de itens. Contate o administrador do sistema."
      when 53005
        "Informe a moeda de pagamento. Contate o administrador do sistema."
      when 53006
        "Moeda inválida. Contate o administrador do sistema."
      when 53007
        "Tamanho da referência é inválido. Contate o administrador do sistema."
      when 53008
        "Tamanho da URL de notificação é inválido. Contate o administrador do sistema."
      when 53009
        "URL de notificação inválida. Contate o administrador do sistema."
      when 53010
        "Email deve ser informado."
      when 53011
        "Tamanho do email inválido."
      when 53012
        "Email fornecido não é válido."
      when 53013
        "Forneça seu nome."
      when 53014
        "Tamanho do nome inválido."
      when 53015
        "Nome inválido."
      when 53017
        "Informe um CPF válido."
      when 53018
        "Informe o DDD."
      when 53019
        "DDD inválido."
      when 53020
        "Informe o telefone."
      when 53021
        "Telefone inválido."
      when 53022
        "Informe o CEP."
      when 53023
        "CEP inválido."
      when 53024
        "Informe a rua."
      when 53025
        "Tamanho do nome da rua inválido."
      when 53026
        "Informe o número da casa/apartamento."
      when 53027
        "Tamanho do número da casa é inválido."
      when 53028
        "Tamanho do complemento é inválido."
      when 53029
        "Informe o bairro."
      when 53030
        "Tamanho do nome do bairo é inválido."
      when 53031
        "Informe uma cidade."
      when 53032
        "Tamanho do nome da cidade é inválido."
      when 53033
        "Informe um estado."
      when 53034
        "Estado informado inválido."
      when 53035
        "É necessário informar o país. Contate o administrador do sistema."
      when 53036
        "Tamanho do nome do país é inválido. Contate o administrador do sistema."
      when 53037
        "Cartão inválido. Verifique se o número, o CVV e a validade do cartão estão corretas."
      when 53038
        "Informe o número de parcelas."
      when 53039
        "Número de parcelas inválido."
      when 53040
        "O valor das parcelas deve ser informado. Contate o administrador do sistema."
      when 53041
        "Insira o número de parcelas."
      when 53042
        "Informe o nome impresso no cartão."
      when 53043
        "Tamanho do nome impresso no cartão inválido."
      when 53044
        "Nome impresso no cartão é inválido."
      when 53045
        "Informe o CPF do dono do cartão de crédito."
      when 53046
        "CPF do dono do cartão de crédito inválido."
      when 53047
        "Informe a data de nascimento do dono do cartão de crédito."
      when 53048
        "Data de nascimento inválida."
      when 53049
        "Informe o DDD do telefone do dono do cartão de crédito."
      when 53050
        "DDD do dono do cartão de crédito inválido."
      when 53051
        "Informe o telefone do dono do cartão de crédito."
      when 53052
        "Telefone do dono do cartão de crédito inválido."
      when 53053
        "Informe o CEP do dono do cartão de crédito."
      when 53054
        "CEP do dono do cartão de crédito inválido."
      when 53055
        "Informe a rua do dono do cartão de crédito."
      when 53056
        "Tamanho do nome da rua do dono do cartão de crédito é inválido."
      when 53057
        "Informe o número da casa/apartamento do dono do cartão de crédito."
      when 53058
        "Tamanho do número da casa do dono do cartão de crédito é inválido."
      when 53059
        "Tamanho do complemento do dono do cartão de crédito é inválido."
      when 53060
        "Informe o bairro do dono do cartão de crédito."
      when 53061
        "Tamanho do nome do bairro do dono do cartão de crédito é inválido."
      when 53062
        "Informe a cidade do dono do cartão de crédito."
      when 53063
        "Tamanho do nome da cidade inválido."
      when 53064
        "Informe o estado do dono do cartão de crédito."
      when 53065
        "Estado informado inválido."
      when 53066
        "País do dono do cartão de crédito deve ser informado. Contate o administrador do sistema."
      when 53067
        "Tamanho do nome do país inválido. Contate o administrador do sistema."
      when 53068
        "Tamanho do email do destinatário é inválido. Contate o administrador do sistema."
      when 53069
        "Email do destinatário inválido. Contate o administrador do sistema."
      when 53070
        "ID do item deve ser informado. Contate o administrador do sistema."
      when 53071
        "Tamanho do ID do item inválido. Contate o administrador do sistema."
      when 53072
        "Descrição do item deve ser informado. Contate o administrador do sistema."
      when 53073
        "Tamanho do nome do item inválido. Contate o administrador do sistema."
      when 53074
        "Quantidade de itens deve ser informada. Contate o administrador do sistema."
      when 53075
        "Quantidade de itens inválida. Contate o administrador do sistema."
      when 53076
        "Quantidade itens inválida. Contate o administrador do sistema."
      when 53077
        "Preço do item deve ser informada. Contate o administrador do sistema."
      when 53078
        "Preço do item deve ter 2 casas decimais. Contate o administrador do sistema"
      when 53079
        "Preço do item inválido. Contate o administrador do sistema."
      when 53081
        "Comprador está relacionado com o vendedor. Contate o administrador do sistema."
      when 53084
        "Destinatário inválido. Contate o administrador do sistema."
      when 53085
        "Método de pagamento indisponível."
      when 53086
        "Preço total inválido. Contate o administrador do sistema."
      when 53087
        "Dados do cartão de crédito inválidos."
      when 53091
        "Identificador do vendedor inválido. Contate o administrador do sistema."
      when 53092
        "Bandeira do cartão não é aceita."
      when 53098
        "Total da compra é negativo. Contate o administrador do sistema."
      when 53099
        "Valor dos encargos é inválido. Contate o administrador do sistema."
      when 53101
        "Modo de pagamento inválido. Contate o administrador do sistema."
      when 53102 
        "Meio de pagamento inválido. Os valores aceitos são: creditCard, boleto e etf. Contate o administrador do sistema."
      when 53105
        "Informe o email."
      when 53106
        "Nome do dono do cartão de crédito está incompleto."
      when 53110
        "Informe o banco para débito online."
      when 53111
        "Banco informado não é aceito"
      when 53115
        "Data de nascimento inválida."
      when 53140
        "Número de parcelas inválida."
      when 53141
        "Mensagem do PagSeguro: você está bloqueado."
      when 53142
        "Token do cartão de crédito inválido."
      end
    end
  end

end