class CheckoutController < ApplicationController

=begin
  @@urlAutenticacao = "https://ws.pagseguro.uol.com.br/v2/sessions?email=EMAIL&token=TOKEN"

  def new
    @id_sessao = get_id_sessao
  end

  def create
    byebug
    # O modo como você irá armazenar os produtos que estão sendo comprados
    # depende de você. Neste caso, temos um modelo Order que referência os
    # produtos que estão sendo comprados.
    #order = Order.find(params[:id])

    payment = PagSeguro::PaymentRequest.new
    payment.reference = "#prod01"
    payment.notification_url = notifications_url
    payment.redirect_url = processing_url

    order.products.each do |product|
      payment.items << {
        id: product.id,
        description: product.title,
        amount: product.price,
        weight: product.weight
      }
    end

    response = payment.register

    # Caso o processo de checkout tenha dado errado, lança uma exceção.
    # Assim, um serviço de rastreamento de exceções ou até mesmo a gem
    # exception_notification poderá notificar sobre o ocorrido.
    #
    # Se estiver tudo certo, redireciona o comprador para o PagSeguro.
    if response.errors.any?
      raise response.errors.join("\n")
    else
      redirect_to response.url
    end
  end

  private

  def get_id_sessao
    @@urlAutenticacao.
      gsub!(/EMAIL/, ENV["EMAIL_PAGSEGURO"]).
      gsub!(/TOKEN/, ENV["TOKEN_PAGSEGURO"])
    uri = URI(@@urlAutenticacao)
    req = Net::HTTP::Post.new(uri)
    
    resp = Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    return Nokogiri::XML(resp.body).xpath('//id').text
  end
=end

  def confirmacao
    byebug
  end

  def new
    
  end

end