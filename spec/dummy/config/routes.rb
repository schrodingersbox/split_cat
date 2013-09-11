Rails.application.routes.draw do

  mount SplitCat::Engine => '/split_cat'

  root :to => 'root#index'
  get '/token', :to => 'root#token'
  get '/goals', :to => 'root#goals'
end
