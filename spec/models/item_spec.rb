require 'rails_helper'

RSpec.describe Item, type: :model do
  item = Item.find_or_create_by(name: 'Test item') do |a|
    a.description = 'An item used for testing purposes',
                    a.location = 'New Delhi',
                    a.price = 2038.5
  end

  describe 'associations' do
    it { should have_many(:reservations).dependent(:destroy) }
    it { should have_many(:users).through(:reservations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(30) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:location) }
    it { should validate_length_of(:location).is_at_least(2).is_at_most(30) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }

    context 'when photo is present' do
      it 'validates photo URL format' do
        item.photo = 'invalid_url'
        expect(item).not_to be_valid
        expect(item.errors[:photo]).to include('must be a valid URL format')

        item.photo = 'https://example.com/image.jpg'
        expect(item).to be_valid
      end
    end

    context 'when photo is not present' do
      it 'does not validate photo URL format' do
        item.photo = nil
        expect(item).to be_valid
      end
    end
  end
end
