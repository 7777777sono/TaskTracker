require 'clockwork'
require './environment'
require './boot'

module Clockwork
    handler do |job|
        case job
        when 'delete_expired_task'
            @tasks = Task.all
            @tasks.each do |task|
                # 締切日が過ぎたらそのタスクを削除する。
                if task.deadline < Date.today
                    puts task.deadline
                    task.destroy
                end
            end
        when 'line_send_notify'
            @users = User.all
            @users.each do |user|
                msg = "あなたが残しているタスクです。\n\n"
                if user.token != nil
                    @tasks = Task.where(user_id: user.id)
                    @tasks.each do |task|
                        if !task.is_complete
                            msg = "#{ msg }#{ task.deadline.year.to_s }/#{ task.deadline.month.to_s }/#{ task.deadline.day.to_s }(#{ I18n.t("date.abbr_day_names")[task.deadline.wday] }) #{task.name}\n"
                        end
                    end
                    LineNotify.send(user.token, msg)
                end
            end
        end
    end

    # 日が変わったら締め切りが過ぎたタスクを消す。
    every(1.day, 'delete_expired_task', at: '00:00')

    # every(30.seconds, 'line_send_notify')
end