module RedmineOmniauthRor
  class Hooks < Redmine::Hook::ViewListener
    def view_account_login_top(context = {})
      context[:controller].send(:render_to_string, {
        :partial => "hooks/view_account_login_top",
        :locals => context})
    end
  end
end
