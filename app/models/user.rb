class User < ActiveRecord::Base
  acts_as_authentic

  validates :account, :presence   => true,
                      :uniqueness => true

  def self.authenticate(account, submitted_password)
    user = find_by_account(account)
    return nil  if user.nil?
    return user if user.valid_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.password_salt == cookie_salt) ? user : nil
  end

end
