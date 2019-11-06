require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_numericality_of :zip }
  end

  describe 'relationships' do
    it { should have_many :orders }
    it { should belong_to :user }
  end

  describe 'instance methods' do
    it 'shipped_orders?' do
      user = User.create!(name: 'Bob', email: 'bobemail.com', password: 'secure')
      address_1 = user.addresses.create!(address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)
      address_2 = user.addresses.create!(address: '234 Park', city: 'Boulder', state: 'CO', zip: 80_113)

      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      tire = meg.items.create!(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)

      order_1 = user.orders.create!(name: 'Bob', status: 1, address_id: address_1.id)
      order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 0)

      order_2 = user.orders.create!(name: 'Bob', status: 2, address_id: address_2.id)
      order_2.item_orders.create!(item: tire, price: tire.price, quantity: 1, status: 1)

      expect(address_1.shipped_orders?).to eq(false)
      expect(address_2.shipped_orders?).to eq(true)
    end
  end
end
