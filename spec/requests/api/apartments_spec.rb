require 'swagger_helper'

describe 'Booking API', type: :request do
  let(:user) { create(:user) }
  let(:bearer) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: 1) }

  it 'Create new item' do
    post '/api/items', headers: {
      'Authorization' => "Bearer #{bearer.token}",
      'Content-Type' => 'application/json'
    } do
      tags 'items'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :item, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          location: { type: :string },
          photo: { type: :string },
          price: { type: :number }
        },
        required: %w[name description location photo price]
      }
      response '200', 'Item created' do
        let(:item) do
          { name: 'Test name',
            description: 'Test description',
            location: 'Test location',
            photo: 'https://images.pexels.com/photos/2510067/pexels-photo-2510067.jpeg',
            price: 999 }
        end
        run_test!
      end
    end
  end

  it 'Receive items list' do
    get '/api/items', headers: {
      'Authorization' => "Bearer #{bearer.token}",
      'Content-Type' => 'application/json'
    } do
      tags 'items'
      security [Bearer: []]
      produces 'application/json'

      response(200, 'Items list received') do
        schema type: :array,
               properties: {
                 name: { type: :string },
                 description: { type: :string },
                 location: { type: :string },
                 photo: { type: :string },
                 price: { type: :number }
               },
               required: %w[name description location photo price]
        run_test!
      end
    end
  end

  let(:id) { create(:item).id }

  it 'Delete item' do
    delete api_item_path(id), headers: {
      'Authorization' => "Bearer #{bearer.token}",
      'Content-Type' => 'application/json'
    } do
      tags 'items'
      security [Bearer: []]
      produces 'application/json'

      response(200, 'Item deleted') do
        run_test!
      end
    end
  end
end
