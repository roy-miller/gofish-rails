class RegisteredUser < User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  # attr_accessible :email, :password, :encrypted_password,
  #                 :password_confirmation, :remember_me
end