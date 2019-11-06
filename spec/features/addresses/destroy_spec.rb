require 'rails_helper'

RSpec.describe 'Delete Address' do
  before(:each) do
    @user = User.create!(name: 'Bob', email: 'bobemail.com', password: 'secure')
    @address_1 = @user.addresses.create!(address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'displays a link to delete an address on the user profile page' do
    visit profile_path

    @user.addresses.each do |address|
      within "#address-#{address.id}" do
        expect(page).to have_link('Delete Address')
      end
    end
  end

  it 'clicking the link will delete the address' do
    address_2 = @user.addresses.create!(address: '234 Park', city: 'Boulder', state: 'CO', zip: 80_113)
    address_2_id = address_2.id

    visit profile_path

    within "#address-#{address_2.id}" do
      click_link 'Delete Address'
    end

    expect(current_path).to eq(profile_path)

    expect("#address-#{address_2_id}").to be_present
  end

  it 'an address with a shipped order may not be deleted' do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    order = @user.orders.create!(name: 'Bob', status: 2, address_id: @address_1.id)
    order.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 1)

    visit profile_path

    within "#address-#{@address_1.id}" do
      expect(page).to_not have_link('Delete Address')
    end
  end
end
