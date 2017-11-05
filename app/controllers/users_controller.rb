class UsersController < ApplicationController
  use Rack::Flash

  get '/login' do
    if logged_in?
      redirect '/authors'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by_username(params[:user][:username])

    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect '/authors'
    else
      user ? (flash[:message] = "Invalid Password") : (flash[:message] = "Username not found")
      redirect '/login'
    end
  end

  get '/signup' do
    if logged_in?
      redirect '/authors'
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    user = User.new(params[:user])

    if user.save
      session[:user_id] = user.id
      redirect '/authors'
    else
      flash[:message] = "Signup unsucessful"
      redirect to "/login"
    end
  end

  get '/logout' do
    session.clear
    flash[:message] = "You have now logged out"
    redirect '/login'
  end


end