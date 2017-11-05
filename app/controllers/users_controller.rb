class UsersController < ApplicationController

  get '/login' do
    erb :'users/login'
  end

  post '/users' do
    user = User.find_by_username(params[:user][:username])

    if user && user.authenticate(params[:user][:password])
      redirect '/authors'
    else
      redirect '/login'
    end
  end


end