class UserSessionLog < ApplicationRecord
    def self.log(resource, new_action)
        return unless User.valid_user?(resource) \
                      && (Rails.configuration.respond_to? :devise_usage_log_level)
    
        level = Rails.configuration.devise_usage_log_level
        if level == :all || (level == :login && new_action == "sign_in") ||(level == :login && new_action == "sign_out")
          resource.log_devise_action(new_action)
        end
    end
end