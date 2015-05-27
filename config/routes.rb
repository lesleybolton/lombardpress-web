Rails.application.routes.draw do
  
  

  
  
  resources :access_requests

  root 'pages#home'

  devise_for :users, controllers: { sessions: "users/sessions", profiles: "users/profiles"}
  
  get 'posts/list' => 'posts#list'
  resources :posts
  
  resources :comments, except: [:new]

  get 'articles/:articleid' => 'articles#show', as: :show_article
  get 'articles' => 'articles#index', as: :articles
  
  get 'biography' => 'pages#biography'
  get 'bibliography' => 'pages#bibliography' 

  get "comments/new/:itemid(/:pid)" => 'comments#new', as: :new_comment
  get "comments/list/:itemid(/:pid)" => 'comments#list', as: :list_comments
  
  get "index" => 'indices/indices#index'
  
  get "index/names/list(/:category)" => 'indices/names#list'
  get "index/names/show(/:nameid)" => 'indices/names#show'
  get "index/names/categories" => 'indices/names#categories'
  
  get "index/titles/list(/:category)" => 'indices/titles#list'
  get "index/titles/show(/:titleid)" => 'indices/titles#show'
  get "index/titles/categories" => 'indices/titles#categories'

  get "index/quotes/list(/:category)" => 'indices/quotes#list'
  get "index/quotes/show(/:quoteid)" => 'indices/quotes#show'
  get "index/quotes/categories" => 'indices/quotes#categories'

  get 'paragraphs/index'
  get 'paragraphs/collation/:itemid/:pid' => 'paragraphs#collation', as: :paragraphs_collation
  get 'paragraphs/xml/:itemid/:pid(/:msslug)' => 'paragraphs#xml', as: :paragraphs_xml
  get 'paragraphs/info'
  get 'paragraphs/plaintext'
  get 'paragraphs/:itemid/:pid(/:msslug)' => 'paragraphs#show'
  
  get 'permissions' => 'pages#permissions'
  
  get 'search' => 'search#show', as: :show_search

  get 'text' => 'text#index'
  get 'text/draft_permissions/:itemid' => 'text#draft_permissions'
  get 'text/questions' => 'text#questions'
  get 'text/info/:itemid' => 'text#info'
  get 'text/status/:itemid' => 'text#status'
  get 'text/toc/:itemid(:/msslug)' => 'text#toc'
  get 'text/xml/:itemid(:/msslug)' => 'text#xml'
  get 'text/:itemid(/:msslug)' => 'text#show', as: :show_text
  
  get 'paragraphimage/showfoliozoom/:msslug/:canvas_id' => 'paragraphimage#showfoliozoom'
  get 'paragraphimage/showzoom/:itemid/:msslug/:pid' => 'paragraphimage#showzoom'
  get 'paragraphimage/:itemid/:msslug/:pid' => 'paragraphimage#show'

  
  get 'users/profiles/:id' => 'users/profiles#show', as: :users_profile
  delete 'users/profiles/:id' => 'users/profiles#destroy', as: :destroy_users_profile
  put 'users/profiles/:id' => 'users/profiles#update', as: :update_users_profile
  post 'users/profiles' => 'users/profiles#create', as: :create_users_profile
  get 'users/profiles' => 'users/profiles#index'

  get 'accesspoints/:commentaryid/:itemid' => 'access_points#show', as: :access_point
  post 'accesspoints/:id' => 'access_points#create', as: :create_access_point
  delete 'accesspoints/:id' => 'access_points#destroy', as: :delete_access_point
  



  

  

  

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
