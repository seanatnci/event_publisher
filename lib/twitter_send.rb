require 'rubygems'
require 'twitter'
require 'twitter_oauth'

class TwitterSend

def initialize(event)
          handle = event.organizer.twitter_handle ##  create method to return handle without exposing organizer
          message = event.title + " at " + event.location.location_name + " on " + event.date.strftime("%d/%m/%Y")
          with_message(handle,message)
end

def with_message(handle,message)
   client = TwitterOAuth::Client.new(
    :consumer_key => '43DnloztUFck2UpTfN17Q',
    :consumer_secret => 'UZSOhR5LnPOoJSIOkrfyjJfz6u908QQXQbxMyjyphM',
    :token => '252655570-cDp9JluHr9KWckvrsN7ad8ifKidC3Rc4X95otmy3',
    :secret => 'VLCj0AmjbFHPPUMt2Yf1oZ2lYUTv8OtkzNN3ACEwJOc'
   )

  mess = client.message(handle,message)
  client.update(mess["text"])
end

end