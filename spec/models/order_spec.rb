# frozen_string_literal: true

require 'rails_helper'

describe Order, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
    it { should belong_to :user }
    it { should belong_to :address }
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)

      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @pull_toy = @brian.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
      @user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )
      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)

      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant_id: @meg.id, status: 1)
      @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, merchant_id: @brian.id, status: 1)
    end

    xit 'grand_total' do
      expect(@order_1.grand_total).to eq(230)
    end

    xit 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end

    xit 'find_order' do
      expect(@order_1.find_order(@meg.id).count).to eq(1)
    end

    xit 'all_items_fulfilled?' do
      expect(@order_1.all_items_fulfilled?).to eq(true)
    end

    xit 'update_status' do
      expect(@order_1.status).to eq('Pending')

      @order_1.update_status(1)

      expect(@order_1.status).to eq('Packaged')
    end

    xit 'packaged?' do
      expect(@order_1.packaged?).to eq(false)

      order_2 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 1)

      expect(order_2.packaged?).to eq(true)
    end
  end

  describe 'class_method' do
    xit 'sort_orders' do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      pull_toy = dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)

      user_1 = User.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user_1@user.com', password: 'secure', role: 0)

      order_1 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 2)
      order_2 = user_1.orders.create(name: 'User 2', address: '987 First', city: 'Dallas', state: 'TX', zip: 75_001, status: 3)
      order_3 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 1)
      order_4 = user_1.orders.create(name: 'User 2', address: '987 First', city: 'Dallas', state: 'TX', zip: 75_001, status: 0)

      expect(Order.sort_orders.to_a).to eq([order_3, order_4, order_1, order_2])
    end
  end
end
