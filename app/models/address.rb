class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :address, :city, :state, :zip

  validates_length_of :zip, is: 5
  validates_numericality_of :zip

  def shipped_orders?
    orders.where(status: 2).any?
  end
end
