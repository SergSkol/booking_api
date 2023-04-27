require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { User.create(name: 'John Doe', email: 'john@example.com', password: 'password123') }
  let(:item) do
    Item.create(name: 'Cozy item', description: 'A cozy item in the heart of the NY',
                photo: 'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg',
                location: 'New York', price: 100)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      reservation = Reservation.new(user:, item:, start_date: Date.today,
                                    end_date: Date.today + 1.week)
      expect(reservation).to be_valid
    end

    it 'is not valid without a user' do
      reservation = Reservation.new(item:, start_date: Date.today, end_date: Date.today + 1.week)
      expect(reservation).to_not be_valid
    end

    it 'is not valid without an item' do
      reservation = Reservation.new(user:, start_date: Date.today, end_date: Date.today + 1.week)
      expect(reservation).to_not be_valid
    end

    it 'is not valid without a start date' do
      reservation = Reservation.new(user:, item:, end_date: Date.today + 1.week)
      expect(reservation).to_not be_valid
    end

    it 'is not valid without an end date' do
      reservation = Reservation.new(user:, item:, start_date: Date.today)
      expect(reservation).to_not be_valid
    end

    it 'is not valid if the start date is after the end date' do
      reservation = Reservation.new(user:, item:, start_date: Date.today + 1.week,
                                    end_date: Date.today)
      expect(reservation).to_not be_valid
    end

    it 'is not valid if the item is already reserved for the same interval' do
      Reservation.create(user:, item:, start_date: Date.today,
                         end_date: Date.today + 1.week)
      new_reservation = Reservation.new(user:, item:, start_date: Date.today,
                                        end_date: Date.today + 1.week)
      expect(new_reservation).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to an item' do
      association = described_class.reflect_on_association(:item)
      expect(association.macro).to eq :belongs_to
    end
  end
end
