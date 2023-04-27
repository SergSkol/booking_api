require 'swagger_helper'

describe 'Booking API', type: :request do
  let(:user) { create(:user) }
  let(:bearer) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: 1) }
  let(:item) { create(:item) }

  path '/api/reservations' do
    it 'Create new reservation' do
      post '/api/reservations', headers: {
        'Authorization' => "Bearer #{bearer.token}",
        'Content-Type' => 'application/json'
      } do
        tags 'reservation'
        security [Bearer: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :reservation, in: :body, schema: {
          type: :object,
          properties: {
            user_id: { type: :string },
            item_id: { type: :string },
            start_date: { type: :string },
            end_date: { type: :string }
          },
          required: %w[user_id item_id start_date end_date]
        }
        response '200', 'Reservation created' do
          let(:reservation) do
            { user_id: user.id,
              item_id: item.id,
              start_date: Date.today,
              end_date: Date.today + 1 }
          end
          run_test!
        end
      end
    end
  end

  path '/api/reservations' do
    it 'Index of reservations' do
      get '/api/reservations', headers: {
        'Authorization' => "Bearer #{bearer.token}",
        'Content-Type' => 'application/json'
      } do
        tags 'reservation'
        security [Bearer: []]
        produces 'application/json'

        response(200, 'Reservation list received') do
          schema type: :array,
                 properties: {
                   user_id: { type: :string },
                   item_id: { type: :string },
                   start_date: { type: :string },
                   end_date: { type: :string }
                 },
                 required: %w[user_id item_id start_date end_date]
          run_test!
        end
      end
    end
  end

  let!(:reservation) do
    Reservation.create(
      user_id: user.id,
      item_id: item.id,
      start_date: Date.today,
      end_date: Date.today + 1
    )
  end

  path '/api/reservations/{reservation_id}' do
    it 'Delete reservation' do
      delete api_reservation_path(reservation.id), headers: {
        'Authorization' => "Bearer #{bearer.token}",
        'Content-Type' => 'application/json'
      } do
        tags 'reservation'
        security [Bearer: []]
        produces 'application/json'

        response(200, 'Reservation deleted') do
          run_test!
        end
      end
    end
  end
end
