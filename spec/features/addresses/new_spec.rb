require 'rails_helper'

RSpec.describe 'New Address' do
  it 'can be created on user profile page' do
    user = User.create(name: 'Bob', email: 'bob@email.com', password: 'secure')
    address = user.addresses.create(street: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path

    click_link 'Add Address'

    expect(current_path).to eq('/profile/addresses/new')

    fill_in :alias, with: 'Office'
    fill_in :street, with: '542 Oak Ave'
    fill_in :city, with: 'Boulder'
    fill_in :state, with: 'CO'
    fill_in :zip, with: '80001'

    click_button 'Create Address'

    expect(current_path).to eq(profile_path)

    within "#address-#{address.id}" do
      expect(page).to have_content("Nickname: #{address.alias}")
      expect(page).to have_content(address.street)
      expect(page).to have_content(address.city)
      expect(page).to have_content(address.state)
      expect(page).to have_content(address.zip)
    end

    new_address = user.addresses.last

    within "#address-#{new_address.id}" do
      expect(page).to have_content("Nickname: #{new_address.alias}")
      expect(page).to have_content(new_address.street)
      expect(page).to have_content(new_address.city)
      expect(page).to have_content(new_address.state)
      expect(page).to have_content(new_address.zip)
    end
  end
end
