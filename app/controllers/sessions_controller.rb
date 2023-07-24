class SessionsController < ApplicationController
    before_action :set_user, only: %i[ destroy ]

    # POST:ログインするアクション
    def create
        # 入力情報が登録したユーザと一致していたら@userに格納させる。
        # そうでなければ空となる。
        @user = User.new(user_params)

        # 登録したユーザと入力情報が一致していたらログインとする。
        if !@user.nil?
            session[:user_id] = @user.id
            format.json { message: "ログイン成功", status: :ok }
        else
            format.json { message: "指定したユーザかパスワードが違います", status: :unauthorized }
        end
    end

    # DELETE: ログアウトするアクション
    def destroy
        session[:user_id] = nil
        format.json { message: "ログアウト成功", status: :ok }
    end

    private
    # idに対応するデータを見つける
    def set_user
        @user = User.find(params[:user_id])
    end

    # 必須のuserパラメータを取得する
    def user_params
        params.require(:user).permit(:name, :password, :google_id)
    end
end
