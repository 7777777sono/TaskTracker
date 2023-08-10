require 'uri'
require 'net/http'

class LineTokensController < ApplicationController
    before_action :set_user, only: %i[ update ]

    # LINEトークンを登録するアクション
    def update
        puts "Token received: #{params[:token]}"

        if @user.update(token: params[:token])
            send_line_notification
            render json: { message: "登録完了です。" }, status: :ok
        else
            puts @user.errors.full_messages # コンソールにエラーメッセージを表示
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    private
    # idに対応するデータを見つける
    def set_user
        @user = User.find(params[:user_id])
    end

    # トークンの登録が完了したらラインを送る
    def send_line_notification
        @user = User.find(params[:user_id])
        token = @user.token
        msg = "#{@user.name}さん 登録ありがとうございます。\n登録したタスクを毎日 7:00, 12:00, 20:00 に通知します。"

        url = 'https://notify-api.line.me/api/notify'
        # 与えられたURLを解析し、その内容を構造化されたオブジェクトとして返す。
        # URLの様々な部分（スキーム、ホスト、パス、クエリパラメータなど）に簡単にアクセスすることが可能
        uri = URI.parse(url)

        # HTTP POSTリクエストを作成する
        request = Net::HTTP::Post.new(uri)

        # AuthorizationヘッダーにBearerトークンを設定して、APIリクエストに認証情報を付与
        request['Authorization'] = "Bearer #{token}"

        # HTTPリクエストのボディをフォームデータとして設定する
        request.set_form_data(message: msg)

        # HTTPS経由でリクエストを送信
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |https|
            https.request(request)
        end
    end
end
