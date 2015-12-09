class User < ActiveRecord::Base
  has_and_belongs_to_many :matches
  scope :real, -> { where(type: [nil, 'RegisteredUser']) }
  scope :robot, -> { where(type: 'RobotUser') }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
end
