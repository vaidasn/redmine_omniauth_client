## Redmine omniauth ROR

This plugin is used to authenticate Redmine users using an OAuth2 provider.

### Installation:

Download the plugin and install required gems:

```console
cd /path/to/redmine/plugins
git clone https://github.com/arlin2050/redmine_omniauth_client.git
cd /path/to/redmine
bundle install
```

Restart the app
```console
touch /path/to/redmine/tmp/restart.txt
```

### Configuration

* Login as a user with administrative privileges. 
* In top menu select "Administration".
* Click "Plugins"
* In plugins list, click "Configure" in the row for "Redmine OAuth Client plugin"
* Configure all fields.
* Check the box near "Enable OAuth authentication"
* Click Apply. 
 
Users can now to use their account to log into your instance of Redmine.

Additionaly
* Setup value Autologin in Settings on tab Authentification

### Authentication Workflow

1. An unauthenticated user requests the URL to your Redmine instance.
2. User clicks the "Login via App" button.
3. The plugin redirects them to a sign in page if they are not already signed into their account.
4. App redirects user back to Redmine, where the OAuth plugin's controller takes over.

One of the following cases will occur:

1. If self-registration is disabled (Under Administration > Settings > Authentication) but force_account_creation option is checked, the account is created and user is redirected to 'my/page'.
2. Otherwise, self-registration method is used to register users.

### TODO

* Access webservices in other formats than json.
* Fonctionnal tests