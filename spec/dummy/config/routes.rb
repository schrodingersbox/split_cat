Rails.application.routes.draw do

  mount SplitCat::Engine => '/split_cat'

  root :to => 'root#index'

end
