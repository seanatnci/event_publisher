class Email < ActiveRecord::Base
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  belongs_to :organizer
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true,
    :uniqueness => true,
       :format   => { :with => email_regex }

end
