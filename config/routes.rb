Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      resources :alignments, only: [:index, :show]
      resources :bwrows, only: [:index, :show]

    end
  end

end
