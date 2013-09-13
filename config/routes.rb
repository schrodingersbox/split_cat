SplitCat::Engine.routes.draw do

  root :to => 'experiments#index'

  resources :experiments, :only => [ :index, :show ]

end
