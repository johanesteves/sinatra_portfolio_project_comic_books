class Author < ActiveRecord::Base
  has_many :comicbooks
  has_many :issues, through: :comicbooks
  belongs_to :user
end