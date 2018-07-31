require 'account_controller'
require 'json'

class RedmineOauthController < AccountController
  def oauth
    if Setting.plugin_redmine_omniauth_client['oauth_authentification']
      session[:back_url] = params[:back_url]
      redirect_to oauth_client.auth_code.authorize_url(:redirect_uri => oauth_callback_url)
    else
      password_authentication
    end
  end

  def oauth_callback
    if params[:error]
      flash[:error] = l(:notice_access_denied, :app => settings['app_name'])
      redirect_to signin_path
    else
      token = oauth_client.auth_code.get_token(params[:code], :redirect_uri => oauth_callback_url)
      result = token.get(settings['site_url'] + settings['ws_url'])
      info = JSON.parse(result.body)
      if info && info[settings['field_username']]
        try_to_login info
      else
        flash[:error] = l(:notice_unable_to_obtain_app_credentials, :app => settings['app_name'])
        redirect_to signin_path
      end
    end
  end

  def try_to_login info
   params[:back_url] = session[:back_url]
   session.delete(:back_url)
   user = User.find_by_login(info[settings['field_username']])
    if user.nil?
      # Create on the fly
      user = User.new
      user.firstname = info[settings['field_firstname']]
      user.lastname = info[settings['field_lastname']]
      user.mail = info[settings['field_email']]
      user.login = info[settings['field_username']]
      user.random_password
      user.register

      # Use registration if defined
      case Setting.self_registration
      when '1'
        register_by_email_activation(user) do
          onthefly_creation_failed(user)
        end
      when '2'
        register_manually_by_administrator(user) do
          onthefly_creation_failed(user)
        end
      when '3'
        register_automatically(user) do
          onthefly_creation_failed(user)
        end
      else
        if settings['force_account_creation']
          register_automatically(user) do
            onthefly_creation_failed(user)
          end
        else
          flash[:error] = l(:unable_create_account)
          redirect_to signin_path
        end
      end
    else
      # Existing record
      if user.active?
        successful_authentication(user)
      else
        # Redmine 2.4 adds an argument to account_pending
        if Redmine::VERSION::MAJOR > 2 or
          (Redmine::VERSION::MAJOR == 2 and Redmine::VERSION::MINOR >= 4)
          account_pending(user)
        else
          account_pending
        end
      end
    end
  end

  def oauth_client
    @client ||= OAuth2::Client.new(settings['client_id'], settings['client_secret'],
      :site => settings['site_url'],
      :authorize_url => settings['auth_url'],
      :token_url => settings['token_url'])
  end

  def settings
    @settings ||= Setting.plugin_redmine_omniauth_client
  end

end
