class User < ActiveRecord::Base
  has_and_belongs_to_many :matches
  scope :real, -> { where(type: [nil, 'RealUser']) }
  scope :robot, -> { where(type: 'RobotUser') }
end
