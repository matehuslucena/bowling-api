Rails.application.routes.draw do
  namespace :v1 do
    resources :games do
      resources :frames, shallow: true
    end
  end
end
