# frozen_string_literal: true

RSpec.describe('Order Creation') do
  describe 'When I check out from my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @mike.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

      @user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/items/#{@tire.id}"
      click_on 'Add To Cart'
      visit "/items/#{@pencil.id}"
      click_on 'Add To Cart'

      visit '/cart'
      click_on 'Checkout'
    end

    it 'I can create a new order' do
      name = 'Bert'
      address = '123 Sesame St.'
      city = 'NYC'
      state = 'New York'
      zip = 10_001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button 'Create Order'

      new_order = Order.last

      expect(current_path).to eq("/orders/#{new_order.id}")

      within '.shipping-address' do
        expect(page).to have_content(name)
        expect(page).to have_content(address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content('2')
        expect(page).to have_content('$40')
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content('1')
        expect(page).to have_content('$100')
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content('1')
        expect(page).to have_content('$2')
      end

      within '#grandtotal' do
        expect(page).to have_content('Total: $142')
      end

      within '#datecreated' do
        expect(page).to have_content(new_order.created_at)
      end
    end

    it 'i cant create order if info not filled out' do
      name = ''
      address = '123 Sesame St.'
      city = 'NYC'
      state = 'New York'
      zip = 10_001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button 'Create Order'

      expect(page).to have_content('Please complete address form to create an order.')
      expect(page).to have_button('Create Order')
    end

    it 'after I create an order, I am taken to the order page and see a status of pending' do
      fill_in :name, with: 'Bert'
      fill_in :address, with: '123 Sesame St.'
      fill_in :city, with: 'NYC'
      fill_in :state, with: 'New York'
      fill_in :zip, with: 10_001

      click_button 'Create Order'

      new_order = Order.last

      expect(current_path).to eq(order_path(new_order))

      expect(page).to have_content('Status: Pending')

      within 'nav' do
        expect(page).to have_content('Cart: 0')
      end
    end
  end
end