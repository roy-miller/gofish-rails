class User < ActiveRecord::Base
  has_and_belongs_to_many :matches
  scope :real, -> { where(type: nil) }
end
