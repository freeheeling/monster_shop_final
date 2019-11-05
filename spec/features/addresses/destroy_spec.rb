require 'rails_helper'

RSpec.describe 'Delete Address' do
  before(:each) do
    @user = User.create!(name: 'Bob', email: 'bobemail.com', password: 'secure')
    @address_1 = @user.addresses.create!(street: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)

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
    address_2 = @user.addresses.create!(street: '234 Park', city: 'Boulder', state: 'CO', zip: 80_113)
    address_2_id = address_2.id

    visit profile_path

    within "#address-#{address_2.id}" do
      click_link 'Delete Address'
    end

    expect(current_path).to eq(profile_path)

    expect("#address-#{address_2_id}").to be_present
  end
end
