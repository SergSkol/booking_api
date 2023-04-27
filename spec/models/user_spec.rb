require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(30) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('huckleberry.finn@marktwain.com').for(:email) }
    it { should_not allow_value('tom.sawyer@marktwain').for(:email) }
    it { should validate_inclusion_of(:role).in_array(%w[user admin]) }
  end

  describe 'associations' do
    it { should have_many(:reservations).dependent(:destroy) }
    it { should have_many(:items).through(:reservations) }
  end

  describe '.authenticate!' do
    password = '123456'
    user = User.find_or_create_by(email: 'test.user@gmail.com') do |u|
      u.name = 'TestUser'
      u.password = password
    end

    it 'returns the user when valid email and password are provided' do
      expect(User.authenticate!(user.email, password)).to eq(user)
    end

    it 'returns nil when invalid email is provided' do
      expect(User.authenticate!('invalidemail@marktwain.com', password)).to be_nil
    end

    it 'returns nil when invalid password is provided' do
      expect(User.authenticate!(user.email, 'invalidpassword')).to be_nil
    end
  end
end
