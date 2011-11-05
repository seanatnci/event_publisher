require 'rubygems'
require 'twitter'
require 'twitter_oauth'

class TwitterSend

def initialize(event)
          handle = event.organizer.twitter_handle ##  create method to return handle without exposing organizer
          message = event.title + " at " + event.location.location_name + " on " + event.date.strftime("%d/%m/%Y")
          handle = "eventsindublin"
          with_message(handle,message)
end

def with_message(handle,message)
   client = TwitterOAuth::Client.new(
    :consumer_key => 'us4M46Ccc6GRkX2ukOyCQ',
    :consumer_secret => 'SdrDi3sc4B1b7g1TLYI2H7as7b07d7TYboSFZs',
    :token => '6749582-D2ObpHnuoavOUDfIpqDbs7MEK7Q08GJEckBDuAXEtJ',
    :secret => 'HKYlZXLsSADpcLMyEFPkIHeCG34kZeNVRfRe7fz5kw'
   )

  mess = client.message(handle,message)
  client.update(mess["text"])
end

end