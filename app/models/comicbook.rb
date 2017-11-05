class Comicbook < ActiveRecord::Base
  belongs_to :author
  has_many :issues
  belongs_to :user
end