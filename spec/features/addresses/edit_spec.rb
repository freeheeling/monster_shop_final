require 'rails_helper'

RSpec.describe 'Edit Address' do
  it 'can be accessed via a link on user profile page' do
    user = User.create(name: 'Bob', email: 'bob@email.com', password: 'secure')
    address = user.addresses.create(address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path

    within "#address-#{address.id}" do
      click_link 'Edit Address'
    end

    expect(current_path).to eq("/profile/addresses/#{address.id}/edit")

    expect(find_field(:alias).value).to eq(address.alias)
    expect(find_field(:address).value).to eq(address.address)
    expect(find_field(:city).value).to eq(address.city)
    expect(find_field(:state).value).to eq(address.state)
    expect(find_field(:zip).value).to eq(address.zip)

    fill_in :alias, with: 'Parents'
    fill_in :address, with: '5540 S Pearl St'
    fill_in :city, with: 'Centennial'
    fill_in :state, with: 'CO'
    fill_in :zip, with: '80122'

    click_button 'Update Address'

    expect(current_path).to eq(profile_path)

    within "#address-#{address.id}" do
      expect(page).to have_content("Nickname: #{address.alias}")
      expect(page).to have_content(address.address)
      expect(page).to have_content(address.city)
      expect(page).to have_content(address.state)
      expect(page).to have_content(address.zip)
      expect(page).to have_link('Edit Address')
    end
  end
end
