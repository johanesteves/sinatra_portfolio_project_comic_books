class AuthorsController < ApplicationController

  get '/authors' do
    @authors = Author.all

    erb :'authors/index'
  end

  get '/authors/new' do
    erb :'authors/new'
  end

  post '/authors' do
    new_author = Author.new(params[:author_name])

    if params[:issue].empty? && param[:comicbook_title].empty?
      "empty"
    else
      "full"
    end

    binding.pry

    new_author.save
    redirect "/authors/#{new_author.id}"
  end
end