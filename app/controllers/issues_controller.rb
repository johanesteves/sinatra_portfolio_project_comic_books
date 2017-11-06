class IssuesController < ApplicationController
  use Rack::Flash

  get '/issues' do
    @issues = Issue.all
    erb :'comicbooks/index'
  end

  get '/comicbooks/new' do
    if logged_in?
      erb :'comicbooks/new'
    else
      no_access
    end
  end

end