class AuthorsController < ApplicationController

  get '/authors' do
    @authors = Author.all

    erb :'authors/index'
  end

  get '/authors/new' do
    erb :'authors/new'
  end

  post '/authors' do
    new_author = Author.new(name: params[:author_name])

    if !params[:issue].values.all? {|i| i.empty?} && !params[:comicbook_title].empty?
      new_issue = Issue.create(title: params[:issue][:title], issue_number: params[:issue][:issue_number].to_i, cover_date: params[:issue][:cover_date].to_i)

      comicbook = Comicbook.find_or_create_by(title: params[:comicbook_title]) << new_issue
      comicbook.save

      new_author.comicbooks << comicbook
    end

    new_author.save
    redirect "/authors/#{new_author.id}"
  end

  get '/authors/:id/edit' do
    @author = Author.find_by_id(params[:id])
    erb :'authors/edit'
  end

  patch '/authors/:id' do
    @author = Author.find_by_id(params[:id])



  end

  get '/authors/:id' do
    @author = Author.find_by_id(params[:id])
    erb :'authors/show'
  end
end