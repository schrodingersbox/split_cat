SplitCat::Engine.routes.draw do

  root :to => 'experiments#index', :as => :split_cat_root

  resources :experiments

end
