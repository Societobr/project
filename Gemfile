source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'mysql2', '~> 0.3.15'
# Gem necessária para Heroku
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Corrigi os problemas gerados pelo Turbolinks na execução de códigos JavaScript - http://railscasts.com/episodes/390-turbolinks
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
# Inclui validações de padrões brasileiros como CPF, CNPJ e etc
gem 'brazilian-rails', '~> 3.3.0'
# Inclui recaptcha ao site
gem "recaptcha", :require => "recaptcha/rails"

gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'

gem "cpf_validator"

gem 'whenever', :require => false

group :test do
  #gem 'shoulda-matchers'
  gem 'cucumber-rails', require: false
  gem "cucumber-rails-training-wheels"
  gem 'database_cleaner'
end

group :development, :test do
	gem 'byebug', '~> 3.1.2'
end
# Permite a criação de recursos sem persistência de objetos como se eles existissem
gem 'active_attr'

gem 'devise'
# Fontes/Imagens de redes sociais, telefones, carta, '>' e etc
gem 'font-awesome-sass'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem "pagseguro-oficial", git: "git://github.com/pagseguro/ruby.git"

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails'

