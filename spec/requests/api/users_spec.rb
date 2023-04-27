require 'swagger_helper'

describe 'Booking API', type: :request do
  # Doorkeeper record in oauth_application with uid/client_id and client_secret
  application = Doorkeeper::Application.find_or_create_by(name: 'React') do |app|
    app.redirect_uri = ''
    app.save!
  end

  # rubocop:disable Metrics/BlockLength
  path '/api/users' do
    post 'Create new user with token' do
      tags 'users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          client_id: { type: :string },
          role: { type: :string },
          password: { type: :string }
        },
        required: %w[name email client_id role password]
      }

      response '200', 'Sign up successfull with returned access token' do
        let(:user) do
          { name: 'Jack',
            email: 'jack@example.com',
            client_id: application.uid,
            role: 'admin',
            password: '123456' }
        end
        run_test!
      end

      response '403', 'Invalid client ID' do
        let(:user) { { name: 'Jack', role: 'admin', email: 'jack@example.com', password: '123456' } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:user) { { client_id: application.uid } }
        run_test!
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
