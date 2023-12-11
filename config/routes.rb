Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers:{
    sessions: "admin/sessions"
  }

  devise_for :users, skip: [:passwords], controllers:{
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  root to:"public/homes#top"
  scope module: :public do
    get 'users/confirm' => 'users#confirm'
    patch 'users/withdraw' => 'users#withdraw'
    resources :users, only: [:show, :update, :edit] do
      get :bookmarks, on: :collection
    end
    get 'posts/search' => 'posts#search'
    resources :posts do
      resources :relationships, only: [:create, :destroy]
      get 'relationships/followings' => 'relationships#followings', as: 'followings'
      get 'relationships/followers' => 'relationships#followers', as: 'followers'
      resource :bookmarks, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:new, :create, :destroy]
    end
  end

  namespace :admin do
    get 'homes/top' => 'homes#top', as: ''
    resources :post, only: [:show]
    resources :users, only: [:index, :show, :edit, :update]
  end

  devise_scope :user do #deviseを使用して新しくルーティング作成
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
