class SessionsController < ApplicationController
    before_action :set_user, only: %i[ destroy ]

    # POST:ログインするアクション
    def create
        # 入力情報が登録したユーザと一致していたら@userに格納させる。
        # そうでなければ空となる。
        @user = User.find_by(email: params[:email])

        # ユーザが存在し、かつパスワードが一致する場合のみログイン成功とする。
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            render json: { data: @user, message: "ログイン成功" }, status: :ok 
        else
            render json: { message: "入力したメールアドレスかパスワードが違います" }, status: :unauthorized
        end
    end

    # DELETE: ログアウトするアクション
    def destroy
        session[:user_id] = nil
        render json: { message: "ログアウト成功" }, status: :ok 
    end
end
