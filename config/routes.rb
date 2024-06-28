Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    if Rails.env.development?
      mount LetterOpenerWeb::Engine, at: "/letter_opener"
    end

    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount Audits1984::Engine => "/console"

  end


  # Defines the root path route ("/")
  root 'loans#new'

  get 'loans', to: redirect('/')
  post 'loans', to: 'loans#create'
  get 'loans/list'
  get 'loans/list/pending', to: 'loans#pending'
  get 'loans/list/out', to: 'loans#out'

  get 'loaners' => 'loaners#list'
  get 'loaners/list', to: redirect('loaners')

  # Defines the checkout path route ("/checkout")
  get "scanner" => "main#scanner"

  # get "checkout" =>

  get "overview" => "main#overview"

  resources :loaners do
    member do
      get :return
      get :enable
      get :disable
      get :repair
      get :broken
    end
  end

  resources :loans do
    member do
      post :checkout # POST /loans/:id/checkout
      post :checkin # POST /loans/:id/checkin
    end
  end

  resources :borrowers, only: [:show, :index]

end
