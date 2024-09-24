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

after_initialize do
  # Code which should run after Rails has finished booting
end
