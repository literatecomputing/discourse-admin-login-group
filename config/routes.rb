# frozen_string_literal: true

DiscourseAdminLoginGroup::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw { mount ::DiscourseAdminLoginGroup::Engine, at: "discourse-admin-login-group" }
