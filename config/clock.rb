require 'clockwork'
require 'uri'
require 'net/http'
require './config/boot'
require './config/environment'
require './config/application'

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
                    token = user.token

                    url = 'https://notify-api.line.me/api/notify'

                    uri = URI.parse(url)

                    request = Net::HTTP::Post.new(uri)

                    request['Authorization'] = "Bearer #{token}"

                    request.set_form_data(message: msg)

                    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |https|
                        https.request(request)
                    end
                end
            end
        end
    end

    # 日が変わったら締め切りが過ぎたタスクを消す。
    every(1.day, 'delete_expired_task', at: '00:00')

    # 毎日7:00, 12:00, 20:00に未完了のタスクを通知する。
    every(1.day, 'line_send_notify', at: ['07:00', '12:00', '19:20','20:00'])
end