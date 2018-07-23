class User < ApplicationRecord

  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :timeoutable, :validatable, :lockable

  has_many :activities

end
