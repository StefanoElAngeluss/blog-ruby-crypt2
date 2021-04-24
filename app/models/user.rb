class User < ApplicationRecord

  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # validates :username, presence: true, uniqueness: {case_sensitive: false}, format: {with: /\A[a-zA-Z0-9 _\.]*\z/}

  devise :database_authenticatable, :registerable, :recoverable, 
         :rememberable, :validatable, :confirmable, :trackable,
         :lockable, :omniauthable, omniauth_providers: [:google, :github, :twitter]


  # Ceci est pour utiliser l'email ou l'username pour le login voir devise.rb dans initializers
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where("lower(username) = :value OR lower(email) = :value", value: login.downcase).first
    else
      where(conditions.to_hash).first
    end
  end

  # Google Omniauth Oauth2
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    unless user
        user = User.create(
          username: data['name'],
          email: data['email'],
          password: Devise.friendly_token[0,20]
        )
    end
    user.confirmed_at = Time.now # Autoconfirm User form omniauth
    user
  end

end
