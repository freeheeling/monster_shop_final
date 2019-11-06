# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should_not allow_value(nil).for(:enabled?) }
  end

  describe 'relationships' do
    it { should have_many :orders }
    it { should have_many :addresses }
    it { should belong_to(:merchant).optional }
  end

  describe 'roles' do
    it 'default user' do
      user = User.create(name: 'Bob', email: 'bob@email.com', password: 'secure')

      expect(user.role).to eq('default')
    end

    it 'merchant_employee' do
      user = User.create(name: 'Bob', email: 'bob@email.com', password: 'secure', role: 1)

      expect(user.role).to eq('merchant_employee')
    end

    it 'merchant_admin' do
      user = User.create(name: 'Bob', email: 'bob@email.com', password: 'secure', role: 2)

      expect(user.role).to eq('merchant_admin')
    end

    it 'site_admin' do
      user = User.create(name: 'Bob', email: 'bob@email.com', password: 'secure', role: 3)

      expect(user.role).to eq('site_admin')
    end
  end

  describe 'instance methods' do
    it 'address?' do
      user_1 = User.create!(name: 'Bob', email: 'bob@email.com', password: 'secure')
      user_2 = User.create!(name: 'Lee', email: 'lee@email.com', password: 'secure')
      address = user_1.addresses.create!(address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233)

      expect(user_1.address?).to eq(true)
      expect(user_2.address?).to eq(false)
    end
  end
end
