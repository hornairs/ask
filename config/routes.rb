Ask::Application.routes.draw do

  devise_for :customers


  scope '/api/twilio', :as => 'twilio' do
    match '/receive/:phone_number' => "twilio#receive"
    match '/error' => "twilio#error"
    match '/finished/:phone_number' => "twilio#finished", :as => 'finished'
  end

  root :to => "dashboard#app"

  constraints :format => :json do
    resources :surveys, :except => [:edit] do
      resources :questions, :only => [:index, :new]
      resources :responses, :only => [:index]
      get :start, :on => :member
    end

    resources :responders, :except => [:edit, :destroy, :create] do
      resources :responses, :only => [:index]
    end

    resources :questions, :only => [:show, :update, :destroy] do
      get :stats, :on => :member
    end

    resources :responses, :only => [:show, :destroy] do
      resources :answers, :only => [:index]
    end
    resources :answers, :only => [:show, :destroy]
  end


  #match '*segments' => "dashboard#app"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
