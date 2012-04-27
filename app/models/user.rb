class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authorizations
  has_many :checkins, :order => 'created_at DESC'

  def self.create_from_auth!(hash)
    created_hash = {:email => hash[:user_info][:email], :name => hash[:user_info][:name] }
    user = (created_hash[:email].nil? ? nil : User.find_by_email(created_hash[:email])) || User.new(created_hash)
    if user.email
      user.confirm!
    elsif user
      user.save!
    end
    user
  end

  def next_check_type
    if ck = checkins.first
      return Checkin::TYPES.keys[ (Checkin::TYPES.keys.index(ck.check_type.to_sym) + 1) % 2 ]
    end
    :wakeup
  end
  
end
