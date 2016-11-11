Rails.application.routes.draw do
  resources :game do
    resources :frame, shallow: true
  end
end
