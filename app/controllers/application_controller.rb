
class ApplicationController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'password_security'
  end

  get '/' do
    "Hello World, Weclome to the first page"
  end

  helpers do

    def logged_in?
      current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def no_access
      flash[:message] = "You must be logged in to access this page"
      redirect '/login'
    end

  end
end