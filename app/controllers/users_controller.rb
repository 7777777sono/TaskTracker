class UsersController < ApplicationController
    before_action :set_user, only: %i[ show edit update destroy ]

    # GET /users or /users.json
    def index
        @users = User.all

        render json: @users, status: :ok 
    end

    # GET /users/1 or /users/1.json
    def show
    end

    # GET /users/new
    def new
        @user = User.new
    end

    # GET /users/1/edit
    def edit
    end

    # POST /users or /users.json
    def create
        @user = User.new(user_params)

        @users = User.all

        is_registered = registered_check

        # 更新じゃなくて登録済みなのに登録しそうだったら登録済みのメッセージを送る。
        if is_registered && !params[:is_update]
            render  json: { message: "登録済みです。" }, status: :ok
            return
        # 更新かつきちんと登録されていたらそのユーザidを送る。
        elsif is_registered && params[:is_update]
            render json: { id: @user.id }, status: :ok
            return
        # 登録してないのに更新しようとしたらidを-1とする。
        elsif !is_registered && params[:is_update]
            render json: { id: -1 }, status: :ok
            return
        end

        if @user.save
            render json: { message: "登録成功です。" }, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /users/1 or /users/1.json
    def update

        if @user.update(user_params)
            render json: { message: "更新完了です。" }, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    # DELETE /users/1 or /users/1.json
    def destroy
        @user.destroy

        # respond_to do |format|
        #     format.json { message: "削除成功です。", status: :no_content }
        # end
    end

    private
    # idに対応するデータを見つける
    def set_user
        @user = User.find(params[:id])
    end

    # 必須のuserパラメータを取得する
    def user_params
        params.require(:user).permit(:name, :password, :google_id, :email)
    end

    # 登録済みかどうかを確認するメソッド
    def registered_check
        @users.each do |element|
            if element.name == @user.name && element.google_id == @user.google_id && element.email == @user.email
                @user = element
                return true
            end
        end
        return false
    end
end
