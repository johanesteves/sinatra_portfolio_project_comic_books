class ApplicationController < Sinatra::Base

  #set :views, Proc.new { File.join(root, "../views/") }
  #register Sinatra::Twitter::Bootstrap::Assets

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
      !!session[:user_id]
    end

  end
end