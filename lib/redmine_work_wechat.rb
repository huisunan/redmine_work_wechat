require_relative 'redmine_work_wechat/patches/models/issue_patch'

module RedmineWorkWechat
  class << self
    def settings_hash
      Setting["plugin_redmine_work_wechat"]
    end

    def enabled?
      settings_hash["enabled"]
    end

    def corpid
      settings_hash["corpid"]
    end

    def agentid
      settings_hash["agentid"]
    end

    def secret
      settings_hash["secret"]
    end

    def proxy
      settings_hash["proxy"]
    end

    def notification_include_details
      settings_hash["notification_include_details"]
    end
  end
end
