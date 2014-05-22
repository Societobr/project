PagSeguro.configure do |config|
  config.token = ENV["TOKEN_PAGSEGURO"]
  config.email = ENV["EMAIL_PAGSEGURO"]
end