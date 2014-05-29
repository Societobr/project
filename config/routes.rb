Rails.application.routes.draw do

  get 'atividades/index'
  get 'atividades/new'
  post 'atividades/new', to: 'atividades#create'
  get '/checkout', to: 'checkout#new', as: 'checkout'
  post '/checkout', to: 'checkout#create'
  post '/notificacoes', to: 'notifications#create'

  root to: "paginas_estaticas#index"

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/contato', to: 'contatos#new', as: 'contatos'
  post '/contato', to: 'contatos#create'
  get '/cadastre-se', to: 'clientes#new', as: 'cadastre-se'
  post '/cadastre-se', to: 'clientes#create', as: 'public_cliente'
  get '/cidades/belo-horizonte', to: 'paginas_estaticas#belo_horizonte'
  get '/nossos-planos',  to: 'paginas_estaticas#planos'
  get '/faq', to: 'paginas_estaticas#faq'
  post '/cupom', to: 'clientes#cupom'
  post '/cards', to: 'clientes#cards_brand'

  scope 'admin' do
    resources :clientes, except: [:create, :new]
    get 'cliente/new', to: 'clientes#new_admin', as: 'new_admin_cliente'
    post 'cliente/new', to: 'clientes#create_admin', as: 'admin_clientes'
    patch 'cliente/:id', to: 'clientes#update', as: 'update_clientes'
    get 'email-expiracao', to: 'contatos#new_email_expiracao', as: 'email_expiracao_planos'
    post 'email-expiracao', to: 'contatos#create_email_expiracao'
    resources :users
  end

  resources :sessions, except: [:new, :destroy]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
