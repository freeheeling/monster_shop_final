# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    xit { should validate_presence_of(:name) }
    xit { should validate_presence_of(:address) }
    xit { should validate_presence_of(:city) }
    xit { should validate_presence_of(:state) }
    xit { should validate_presence_of(:zip) }
    xit { should validate_numericality_of(:zip) }
    xit { should validate_presence_of(:email) }
    xit { should validate_uniqueness_of(:email) }
    xit { should validate_presence_of(:password) }
    xit { should_not allow_value(nil).for(:enabled?) }
  end

  describe 'relationships' do
    it { should have_many :orders }
    xit { should belong_to(:merchant).optional }
  end

  describe 'roles' do
    xit 'default user' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure'
      )

      expect(user.role).to eq('default')
    end

    xit 'merchant_employee' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure',
        role: 1
      )

      expect(user.role).to eq('merchant_employee')
    end

    xit 'merchant_admin' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure',
        role: 2
      )

      expect(user.role).to eq('merchant_admin')
    end

    xit 'site_admin' do
      user = User.create(
        name: 'Bob',
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233,
        email: 'bob@email.com',
        password: 'secure',
        role: 3
      )

      expect(user.role).to eq('site_admin')
    end
  end
end
