# frozen_string_literal: true

Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  resource_owner_from_credentials do |_routes|
    User.authenticate!(params[:email], params[:password])
  end

  # grant_flows %w[authorization_code client_credentials password]

  grant_flows %w[password]

  use_refresh_token

  # client_credentials :from_basic, :from_params

  # access_token_methods :from_bearer_authorization, :from_access_token_param, :from_bearer_param

  # access_token_expires_in 1.hour

  allow_blank_redirect_uri true
  
  skip_authorization { Rails.env.test? }
end
