Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      resources :alignments, only: [:index, :show]
      resources :tags, only: [:index, :show]

    end
  end

end
