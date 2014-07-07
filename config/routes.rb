get 'oauth_client', :to => 'redmine_oauth#oauth'
get 'oauth_client_callback', :to => 'redmine_oauth#oauth_callback', :as => 'oauth_callback'
