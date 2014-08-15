class Material < ActiveRecord::Base

  validates :price, presence: true, numericality: true
  validates :color, presence: true, uniqueness: true

end
