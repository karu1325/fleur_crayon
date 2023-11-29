Rails.application.routes.draw do

  root to:"public/homes#top"
  scope module: :public do
    get 'users' => 'users#show'
    get 'users/information/edit' => 'users#edit'
    patch 'users' => 'users#update'
    get 'users/confirm' => 'users#confirm'
    patch 'users/withdraw' => 'users#withdraw'
    resources :posts
    get 'posts/search' => 'posts#search'
    resources :relationships, only: [:create, :destroy]
    get 'relationships/followings' => 'relationships#followings'
    get 'relationships/followers' => 'relationships#followers'
    resources :bookmarks, only: [:create, :destroy, :index]
    resources :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:new, :create, :destroy]
  end

  namespace :admin do
    get 'homes/top' => 'homes#top', as: ''
    resources :post, only: [:show]
    resources :users, only: [:index, :show, :edit, :update]
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers:{
    sessions: "admin/sessions"
  }

  devise_for :users, skip: [:passwords], controllers:{
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_scope :user do #deviseを使用して新しくルーティング作成
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
