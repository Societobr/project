class CheckoutController
  protected

  def self.start(params)
    # url = "https://ws.sandbox.pagseguro.uol.com.br/v2/transactions"
    url = "https://ws.pagseguro.uol.com.br/v2/transactions"
    postParams = post_params(params)
    uri = URI(url)
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(postParams)

    resp = Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    return resp
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
      "itemAmount1" => '%.2f'%params[:preco],
      "itemQuantity1" => 1,
      "reference" => params[:reference],
      "senderEmail" => params[:email], #colocar email do cliente aqui
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
      "installmentQuantity" => params[:num_parcelas],
      "installmentValue" => params[:valor_parcelas],
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
    # urlAutenticacao = "https://ws.sandbox.pagseguro.uol.com.br/v2/sessions?email=EMAIL&token=TOKEN"
    urlAutenticacao = "https://ws.pagseguro.uol.com.br/v2/sessions?email=EMAIL&token=TOKEN"
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

end