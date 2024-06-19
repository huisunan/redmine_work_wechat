module RedmineWorkWechat
  module Patches
    module Models
      module JournalPatch
        include RedmineWorkWechat::Helper

        def self.prepended(base)
          base.class_eval do
            after_create_commit :send_notification
          end
        end

        def send_notification
          unless RedmineWorkWechat::available?
            return
          end

          work_wechat_users = []
          journal = self
          users = journal.notified_users | journal.notified_watchers | journal.notified_mentions | journal.journalized.notified_mentions
          users.select! do |user|
            journal.notes? || journal.visible_details(user).any?
          end
          users.each do |user|
            work_wechat_users << get_user_we_com_id(user)
          end

          if issue.author.pref.no_self_notified
            we_com_id = get_user_we_com_id(issue.author)
            if we_com_id
              work_wechat_users -= we_com_id if work_wechat_users.is_a?(Array)
            end
          end

          work_wechat_users = work_wechat_users.compact

          if work_wechat_users.length == 0
            return
          end

          content = "`#{l('text_updated_issue')}`\n"
          content += render_markdown(journal.user, journal.journalized, journal)
          RedmineWorkWechat::WorkWechat.deliver_markdown_msg(work_wechat_users, content)
        end

      end
    end
  end
end

Journal.prepend RedmineWorkWechat::Patches::Models::JournalPatch
