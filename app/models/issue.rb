class Issue < ActiveRecord::Base
  belongs_to :comicbook
  belongs_to :user
end