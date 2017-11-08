class AuthorsController < ApplicationController

  get '/authors' do
    @authors = Author.all
    erb :'authors/index'
  end

  get '/authors/new' do
    if logged_in?
      erb :'authors/new'
    else
      no_access
    end
  end

  post '/authors' do
    new_author = Author.new(name: params[:author_name], user: current_user)

    if !params[:comicbook_title].empty?
      comicbook = Comicbook.find_by(title: params[:comicbook_title]) ||  Comicbook.create(title: params[:comicbook_title], user: current_user)

      if params[:issue].values.all? {|i| !i.empty?}
        new_issue = Issue.create(title: params[:issue][:title], issue_number: params[:issue][:issue_number].to_i, cover_date: params[:issue][:cover_date].to_i, user: current_user)

        if params[:file]
          filename = params[:file][:filename]
          file = params[:file][:tempfile]

          File.open("./public/#{new_issue.id}-#{filename}", 'wb') do |f|
            f.write(file.read)
          end
        end

        comicbook.issues << new_issue
      end

      comicbook.save
      new_author.comicbooks << comicbook
    end


    new_author.save
    redirect "/authors/#{new_author.id}"
  end

  get '/authors/:id/edit' do
    if current_user.authors.find_by(id: params[:id])
      @author = Author.find_by_id(params[:id])
      erb :'authors/edit'
    else
      redirect "/authors/#{params[:id]}"
    end
  end

  patch '/authors/:id' do
    @author = Author.find_by_id(params[:id])
    @author.update(params[:author])

    redirect "/authors/#{@author.id}"
  end

  delete '/authors/:id/delete' do
    author = Author.find_by_id(params[:id])
    issues_deleted = 0
    comicbooks_deleted = 0

    if author.comicbooks.any?
      comicbooks_deleted = author.comicbooks.count do |comicbook|
        issues_deleted = (comicbook.issues.any?) ? comicbook.issues.count {|i| i.delete} : 0
        comicbook.delete
      end
    end

    author.delete if current_user.authors.find_by(id: params[:id])

    flash[:success] = "Author deleted. Comicbooks deleted #{comicbooks_deleted}. Issues deleted: #{issues_deleted}"
    redirect '/authors'
  end

  get '/authors/:id' do
    if @author = Author.find_by_id(params[:id])
      erb :'authors/show'
    else
      redirect '/authors'
    end

  end
end