require 'redmine'
require_dependency 'redmine_omniauth_client/hooks'

Redmine::Plugin.register :redmine_omniauth_client do
  name 'Redmine OAuth Client plugin'
  author 'Andre Cardoso <acardoso@orupaca.fr>'
  description 'This is a plugin for Redmine registration through OAuth 2.0 protocole.'
  version '0.0.1'
  url 'https://github.com/arlin2050/redmine_omniauth_client.git'

  settings :default => {
    :app_name => "Application name",
    :site_url => "http://example.net",
    :auth_url => "/oauth/v2/auth",
    :token_url => "/oauth/v2/token",
    :ws_url => "/current.json",
    :client_id => "",
    :client_secret => "",
    :field_username => "",
    :field_email => "",
    :field_firstname => "",
    :field_lastname => "",
    :force_account_creation => true,
    :oauth_autentification => false,
  }, :partial => 'settings/client_settings'
end
