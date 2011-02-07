class Setting

  def self.googleapi
    @@google = 'ABQIAAAAcKTzoKqP7-gJQjEsftT2aBTb2Ji8DwIIXKrcNOHfPzN_MZWxwBRmdb2mon43fj7jXO9ZxJ9j8amWhQ' if Rails.env.production?
    @@google = 'ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA' if Rails.env.development?
    @@google
  end
end