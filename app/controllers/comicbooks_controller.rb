class ComicbooksController < ApplicationController
  use Rack::Flash

  get '/comicbooks' do
    @comicbooks = Comicbook.all
    erb :'comicbooks/index'
  end

  get '/comicbooks/new' do
    if logged_in?
      erb :'comicbooks/new'
    else
      no_access
    end
  end

  post '/comicbooks' do
    new_comicbook = Comicbook.new(title: params[:comicbook_title], user: current_user)

    if !params[:issue].values.all? {|i| i.empty?}
      new_issue = Issue.create(title: params[:issue][:title], issue_number: params[:issue][:issue_number].to_i, cover_date: params[:issue][:cover_date].to_i, user: current_user)
      new_comicbook.issues << new_issue
    end

    author = Author.find_by(name: params[:author_name]) ||  Author.create(name: params[:author_name], user: current_user)
    author.comicbooks << new_comicbook
    author.save

    redirect "/comicbooks/#{new_comicbook.id}"
  end

  get '/comicbooks/:id/edit' do
    if current_user.comicbooks.find_by(id: params[:id])
      @comicbook = Comicbook.find_by_id(params[:id])
      erb :'comicbooks/edit'
    else
      redirect "/comicbooks/#{params[:id]}"
    end

  end

  patch '/comicbooks/:id' do
    @comicbook = Comicbook.find_by_id(params[:id])
    @comicbook.update(params[:comicbook])

    redirect "/comicbooks/#{@comicbook.id}"
  end

  delete '/comicbooks/:id/delete' do
    comicbook = Comicbook.find_by_id(params[:id])
    comicbook.delete if current_user.comicbooks.find_by(id: params[:id])

    redirect '/comicbooks'
  end


  get '/comicbooks/:id' do
    if @comicbook = Comicbook.find_by_id(params[:id])
      erb :'comicbooks/show'
    else
      redirect '/comicbooks'
    end
  end


end