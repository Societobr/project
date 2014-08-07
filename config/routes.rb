Rails.application.routes.draw do

  root to: "paginas_estaticas#index"
  # post '/notificacoes', to: 'notifications#create'
  # get 'login', to: 'sessions#new', as: 'login'
  # get 'logout', to: 'sessions#destroy', as: 'logout'
  # get '/contato', to: 'contatos#new', as: 'contatos'
  # post '/contato', to: 'contatos#create'
  # get '/cadastre-se', to: 'clientes#new', as: 'cadastre-se'
  # post '/cadastre-se', to: 'clientes#create', as: 'public_cliente'

  # get '/cadastro', to:'clientes#new_sem_pagamento', as: 'cadastro'
  # post '/cadastro', to: 'clientes#create_sem_pagamento'

  # get '/6softwares' => redirect('http://www.6softwares.com.br'), as: 'six_softwares'
  
  # get '/cidades/belo-horizonte', to: 'paginas_estaticas#belo_horizonte'
  # get '/nossos-planos',  to: 'paginas_estaticas#planos'
  # get '/faq', to: 'paginas_estaticas#faq'
  # post '/cupom', to: 'clientes#cupom'
  # post '/cards', to: 'clientes#cards_brand'
  # post '/client', to: 'atividades#find_client'
  # get '/cadastro-amigo', to: 'clientes#new_amigo'
  # post '/cadastro-amigo', to: 'clientes#create_amigo'
  # get '/consultar-status-cadastro', to: 'clientes#consultar_status_cadastro'
  # post '/consultar-status-cadastro', to: 'clientes#status_cadastro'

  # scope 'admin' do
  #   resources :clientes, except: [:create, :new]
  #   get 'atividades', to: 'atividades#index', as: 'atividades'
  #   post 'atividades', to: 'atividades#filter'
  #   get 'cliente/new', to: 'clientes#new_admin', as: 'new_admin_cliente'
  #   post 'cliente/new', to: 'clientes#create_admin', as: 'admin_clientes'
  #   patch 'cliente/:id', to: 'clientes#update', as: 'update_clientes'
  #   get 'email-expiracao', to: 'contatos#edit_email_expiracao', as: 'email_expiracao_plano'
  #   patch 'email-expiracao', to: 'contatos#update_email_expiracao'
  #   get 'email-cadastro', to: 'contatos#edit_email_cadastro_efetuado', as: 'email_cadastro_efetuado'
  #   patch 'email-cadastro', to: 'contatos#update_email_cadastro_efetuado'
  #   get 'email-pagamento-recebido', to: 'contatos#edit_email_pagamento_recebido', as: 'email_pagamento_recebido'
  #   patch 'email-pagamento-recebido', to: 'contatos#update_email_pagamento_recebido'
  #   get 'email-aviso-amigo', to: 'contatos#edit_email_aviso_amigo', as: 'email_aviso_amigo'
  #   patch 'email-aviso-amigo', to: 'contatos#update_email_aviso_amigo'
  #   get 'email-cpj-ja-cadastrado', to: 'contatos#edit_email_cpf_ja_cadastrado', as: 'email_cpf_ja_cadastrado'
  #   patch 'email-cpj-ja-cadastrado', to: 'contatos#update_email_cpf_ja_cadastrado'
  #   get 'email-pagamento-recusado', to: 'contatos#edit_email_pagamento_recusado', as: 'email_pagamento_recusado'
  #   patch 'email-pagamento-recusado', to: 'contatos#update_email_pagamento_recusado'
  #   resources :users
  # end

  # scope 'parceiro' do
  #   get 'atividades/new', to: 'atividades#new', as: 'new_atividade'
  #   post 'atividades/new', to: 'atividades#create'
  # end

  # resources :sessions, except: [:new, :destroy]

  # # The priority is based upon order of creation: first created -> highest priority.
  # # See how all your routes lay out with "rake routes".

  # # You can have the root of your site routed with "root"
  # # root 'welcome#index'

  # # Example of regular route:
  # #   get 'products/:id' => 'catalog#view'

  # # Example of named route that can be invoked with purchase_url(id: product.id)
  # #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # # Example resource route (maps HTTP verbs to controller actions automatically):
  # #   resources :products

  # # Example resource route with options:
  # #   resources :products do
  # #     member do
  # #       get 'short'
  # #       post 'toggle'
  # #     end
  # #
  # #     collection do
  # #       get 'sold'
  # #     end
  # #   end

  # # Example resource route with sub-resources:
  # #   resources :products do
  # #     resources :comments, :sales
  # #     resource :seller
  # #   end

  # # Example resource route with more complex sub-resources:
  # #   resources :products do
  # #     resources :comments
  # #     resources :sales do
  # #       get 'recent', on: :collection
  # #     end
  # #   end

  # # Example resource route with concerns:
  # #   concern :toggleable do
  # #     post 'toggle'
  # #   end
  # #   resources :posts, concerns: :toggleable
  # #   resources :photos, concerns: :toggleable

  # # Example resource route within a namespace:
  # #   namespace :admin do
  # #     # Directs /admin/products/* to Admin::ProductsController
  # #     # (app/controllers/admin/products_controller.rb)
  # #     resources :products
  # #   end
end
