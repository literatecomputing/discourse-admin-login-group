# frozen_string_literal: true

# name: discourse-admin-login-group
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_admin_login_group_enabled

module ::DiscourseAdminLoginGroup
  PLUGIN_NAME = "discourse-admin-login-group"
end

require_relative "lib/discourse_admin_login_group/engine"
# require_relative "lib/discourse_admin_login_group/override-login-groups"


after_initialize do
  # Code which should run after Rails has finished booting
  # 
  #

  UsersController.class_eval do
  def admin_login
    return redirect_to(path("/")) if current_user
    puts UsersController.instance_methods(false)

    ## for some reason we can't call super?
    ## so we have to copy the code from the parent controller
    ## and then add our own code.
    ## it'll be broken if the parent code changes    
    if defined?(super)
      puts "SUPER IS DEFINED!!!!!!! Can can sup it up"
      sleep 5
    end

    puts "USERS CONTROLLER ADMIN LOGIN. . . now"

    if request.put? && params[:email].present?
      RateLimiter.new(nil, "admin-login-hr-#{request.remote_ip}", 6, 1.hour).performed!
      RateLimiter.new(nil, "admin-login-min-#{request.remote_ip}", 3, 1.minute).performed!

      user = nil
      if SiteSetting.discourse_admin_login_group_enabled
        user = User.with_email(params[:email]).human_users.first
      else
         user = User.with_email(params[:email]).admins.human_users.first
      end
      if user 
        email_token =
          user.email_tokens.create!(email: user.email, scope: EmailToken.scopes[:email_login])
        token_string = email_token.token
        token_string += "?safe_mode=no_plugins,no_themes" if params["use_safe_mode"]
        Jobs.enqueue(
          :critical_user_email,
          type: "admin_login",
          user_id: user.id,
          email_token: token_string,
        )
        @message = I18n.t("admin_login.success")
      else
        @message = I18n.t("admin_login.errors.unknown_email_address")
      end
    end

    render layout: "no_ember"
  rescue RateLimiter::LimitExceeded
    @message = I18n.t("rate_limiter.slow_down")
    render layout: "no_ember"
  end
  end


  SessionController.class_eval do
    protected 
    def check_local_login_allowed(user: nil, check_login_via_email: false)
      # admin-login can get around enabled SSO/disabled local logins
      puts "======================YESSSSSS"
      return true
      return true if SiteSetting.discourse_admin_login_group_enabled && user&.admin?
      return if user&.admin?

      if (check_login_via_email && !SiteSetting.enable_local_logins_via_email) ||
          SiteSetting.enable_discourse_connect || !SiteSetting.enable_local_logins
        raise Discourse::InvalidAccess, "SSO takes over local login or the local login is disallowed."
      end
    end
  end
end
