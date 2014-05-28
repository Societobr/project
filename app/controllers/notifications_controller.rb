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

    url = "https://ws.sandbox.pagseguro.uol.com.br/v2/transactions/notifications/#{params[:notificationCode]}?email=EMAIL&token=TOKEN"
    url.gsub!(/EMAIL/, ENV["EMAIL_PAGSEGURO"]).gsub!(/TOKEN/, ENV["TOKEN_PAGSEGURO"])

    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req.add_field('Access-Control-Allow-Origin','https://sandbox.pagseguro.uol.com.br')
    
    resp = Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    render nothing: true, status: 200
  end
end