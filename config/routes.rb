Rails.application.routes.draw do
  root to: 'dashboards#index'
  get 'dashboards', to: 'dashboards#index'
end
