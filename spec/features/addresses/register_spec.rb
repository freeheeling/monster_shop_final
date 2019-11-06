require 'rails_helper'

RSpec.describe 'User Registration' do
 it 'initial address entry defaults as \'Home\' in address database' do
   visit welcome_path

   click_link 'Register'

   expect(current_path).to eq(register_path)

   fill_in :name, with: 'Bob'
   fill_in :address, with: '123 Main St'
   fill_in :city, with: 'Denver'
   fill_in :state, with: 'CO'
   fill_in :zip, with: 80_233
   fill_in :email, with: 'bob@email.com'
   fill_in :password, with: 'password'
   fill_in :password_confirmation, with: 'password'

   click_button 'Create User'

   expect(current_path).to eq(profile_path)

   within '.addresses' do
     expect(page).to have_content('Nickname: Home')
     expect(page).to have_content('123 Main St')
     expect(page).to have_content('Denver')
     expect(page).to have_content('CO')
     expect(page).to have_content('80233')
   end
 end
end
