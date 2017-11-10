class UsersController < ApplicationController

  get '/login' do
    if logged_in?
      redirect '/comicbooks'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by_username(params[:user][:username])

    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      flash[:success] = "Sucessfully logged in"
      redirect '/comicbooks'
    else
      user ? (flash[:danger] = "Invalid Password") : (flash[:danger] = "Username not found")
      redirect to "/login"
    end
  end

  get '/signup' do
    if logged_in?
      redirect '/comicbooks'
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    binding
    if User.find_by_username(params[:user][:username])
      flash[:danger] = "This username already exists!"
      redirect '/signup'
    else
      user = User.new(params[:user])
      if user.save
        session[:user_id] = user.id
        flash[:success] = "You have sucessfully signed-up"
        redirect '/comicbooks'
      else
        flash[:danger] = "Signup unsucessful. Please try again"
        redirect "/login"
      end
    end

  end

  get '/logout' do
    session.clear
    flash[:info] = "You are now logged out"
    redirect '/login'
  end


end