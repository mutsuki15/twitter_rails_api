# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  
  validates :name, presence: true, length: { maximum: 16 }, uniqueness: true
  validates :phone, presence: true
  validates :birthday, presence: true

  include DeviseTokenAuth::Concerns::User
end