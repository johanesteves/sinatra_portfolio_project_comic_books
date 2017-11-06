class IssuesController < ApplicationController

  get '/issues' do
    @issues = Issue.all
    erb :'issues/index'
  end

  get '/issues/new' do
    if logged_in?
      erb :'issues/new'
    else
      no_access
    end
  end

  get '/issues/:id/edit' do
    if current_user.issues.find_by(id: params[:id])
      @issue = Issue.find_by_id(params[:id])
      erb :'issues/edit'
    else
      redirect "/issues/#{params[:id]}"
    end

  end


  patch '/issues/:id' do
    @issue = Issue.find_by_id(params[:id])
    @issue.update(params[:issue])

    comicbook = Comicbook.find_by(title: params[:comicbook][:title]) ||  Comicbook.create(name: params[:comicbook][:title], user: current_user)
    comicbook.isssues << @issue
    comicbook.save

    author = Author.find_by(name: params[:comicbook][:author]) ||  Author.create(name: params[:comicbook][:author], user: current_user)
    author.comicbooks << @comicbook
    author.save

    redirect "/issues/#{@issue.id}"
  end

  delete '/issues/:id/delete' do
    issue = Comicbook.find_by_id(params[:id])
    issue.delete if current_user.issues.find_by(id: params[:id])

    redirect '/issues'
  end

  get '/issues/:id' do
    if @issue = Issue.find_by_id(params[:id])
      filename = Dir["public/#{@issue.id}*"]
      if !filename.empty?
        @filename = filename.first.split("/")[-1]
      end
      binding
      erb :'issues/show'
    else
      redirect '/issues'
    end
  end

end