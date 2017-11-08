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

  post '/issues' do
    new_issue = Issue.new(params[:issue])
    new_issue.user = current_user

    comicbook = Comicbook.find_by(title: params[:comicbook_title].strip) ||  Comicbook.create(title: params[:comicbook_title].strip, user: current_user)
    comicbook.issues << new_issue
    comicbook.save

    if params[:file]
      filename = params[:file][:filename]
      file = params[:file][:tempfile]

      File.open("./public/#{new_issue.id}/-#{filename}", 'wb') do |f|
        f.write(file.read)
      end

    end

    redirect "/issues/#{new_issue.id}"
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

    if params[:file]
      filename = params[:file][:filename]
      file = params[:file][:tempfile]

      File.open("./public/#{new_issue.id}-#{filename}", 'wb') do |f|
        f.write(file.read)
      end
    end

    comicbook = Comicbook.find_by(title: params[:comicbook_title].strip) ||  Comicbook.create(title: params[:comicbook_title].strip, user: current_user)
    comicbook.issues << @issue
    comicbook.save

    redirect "/issues/#{@issue.id}"
  end

  delete '/issues/:id/delete' do
    issue = Issue.find_by_id(params[:id])
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