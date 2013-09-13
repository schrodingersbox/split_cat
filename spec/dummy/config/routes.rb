Rails.application.routes.draw do

  mount SplitCat::Engine => '/split_cat'

  root :to => 'root#index'

  get '/token', :to => 'root#token'
  get '/goal', :to => 'root#goal'

  get '/login', :to => 'root#login'
  get '/logout', :to => 'root#logout'
  get '/unauthorized', :to => 'root#unauthorized'

  get '/admin', :to => 'admin#index'
end
