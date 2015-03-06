Rails.application.routes.draw do
  scope path: :api do
    mount Web => '/web'
  end
end
