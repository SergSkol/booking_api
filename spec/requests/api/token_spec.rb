require 'swagger_helper'

describe 'Booking API', type: :request do
  # Doorkeeper record in oauth_application with uid/client_id and client_secret
  application = Doorkeeper::Application.find_or_create_by(name: 'React') do |app|
    app.redirect_uri = ''
    app.save!
  end

  let(:user) { create(:user) }

  path '/oauth/token' do
    post 'Receive token for existing user' do
      tags 'users'
      consumes 'application/json'
      parameter name: :token, in: :body, schema: {
        type: :object,
        properties: {
          grant_type: { type: :string },
          email: { type: :string },
          password: { type: :string },
          client_id: { type: :string },
          client_secret: { type: :string }
        },
        required: %w[grant_type email password client_id client_secret]
      }

      response '200', 'Returned access token' do
        let(:token) do
          { grant_type: 'password',
            email: user.email,
            password: user.password,
            client_id: application.uid,
            client_secret: application.secret }
        end
        run_test!
      end
    end
  end
end
