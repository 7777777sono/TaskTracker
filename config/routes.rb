Rails.application.routes.draw do
  # resourcesで基本の機能が行えるURLが作成される。
  # userモデルが親でtaskモデルが子になる。
  # shallowルートによって親リソースのIDを指定せずにリクエスト可能
  shallow do
    resources :users do
      resources :tasks
    end
  end

  post '/sessions', to: 'sessions#create'
  delete '/sessions/:user_id', to: 'sessions#destroy'
end
