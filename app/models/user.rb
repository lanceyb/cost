class User < ActiveRecord::Base
  extend Enumerize
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable

  enumerize :role, in: {staff: 0, admin: 1}, default: :staff, scope: true, predicates: true

  validates :role, :login, presence: true
end
