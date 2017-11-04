class ApplicationController < Sinatra::Base

  set :views, Proc.new { File.join(root, "../views/") }
  #register Sinatra::Twitter::Bootstrap::Assets

  get '/' do
    "Hello World, Weclome to the first page"
  end
end