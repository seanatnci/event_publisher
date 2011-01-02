# == Schema Information
#
# Table name: events
#
#  id           :integer(4)      not null, primary key
#  organizer_id :integer(4)      not null
#  title        :string(45)      not null
#  description  :string(255)     not null
#  category_id  :integer(4)      not null
#  date         :string(10)      not null
#  end_date     :string(10)      not null
#  start_time   :integer(4)      not null
#  location_id  :integer(4)      not null
#  cost         :string(4)       not null
#  event_url    :string(255)
#

class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :organizer
  belongs_to :category
  validates :title,  :presence => true,
                     :length   => { :maximum => 50 }
  validates :description, :presence => true
                 
  validates :date,  :presence => true
  validates :end_date,  :presence => true
  validates :start_time,  :presence => true
  validates :category_id,  :presence => true
  validates :location_id,  :presence => true


  validates_with EventDateValidator

  def validate_date
    @start = Date.strptime(self.date,"%d/%m/%Y")
    @end = Date.strptime(self.end_date,"%d/%m/%Y")
    errors.add :date, "End Date Must Be Greater Than Start Date" if (@end < @start)
  end

end
