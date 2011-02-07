# == Schema Information
#
# Table name: organizers
#
#  id                     :integer(4)      not null, primary key
#  user                   :string(45)      not null
#  organization           :string(255)     not null
#  email                  :string(45)      not null
#  primary_event_location :integer(4)      not null
#  event_home_page        :string(255)     not null
#  twitter_handle         :string(45)
#

class Organizer < ActiveRecord::Base
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  urlregex = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  has_many :emails
 

  validates :user,  :presence => true,
                    :length   => { :maximum => 45 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex }

  validates :organization,  :presence => true,
                    :length   => { :maximum => 45 }
  validates :event_home_page, :presence => true,
                     :format   => { :with => urlregex }


end
