class TasksController < ApplicationController
    before_action :action_check
    before_action :set_task, only: %i[ show edit update destroy ]

    # GET /users/:user_id/tasks or /users/:user_id/tasks.json
    def index
        # ユーザが登録したタスクをすべて取得
        @tasks = Task.where(user_id: params[:user_id])

        render json: @tasks, status: :ok 
    end

    # GET /tasks/1 or /tasks/1.json
    def show
    end

    # GET /tasks/new
    def new
        @task = Task.new
    end

    # GET /tasks/1/edit
    def edit
    end

    # POST /users/:user_id/tasks or /users/:user_id/tasks.json
    def create
        @task = Task.new(task_params)

        if @task.save
            render json: { message: "登録成功です。" }, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /tasks/1 or /tasks/1.json
    def update
        if @task.update(task_params)
            render json: { message: "更新完了です。" }, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    # DELETE /tasks/1 or /tasks/1.json
    def destroy
        @task.destroy

        # respond_to do |format|
        #     format.json { message: "削除成功です。", status: :no_content }
        # end
    end

    private
    # idに対応するデータを見つける
    def set_task
        @task = Task.find(params[:id])
    end

    # 必須のtaskパラメータを取得する
    def task_params
        params.require(:task).permit(:name, :deadline, :priority, :is_complete, :user_id)
    end

    # ログインしてないとtaskは、操作できないのでログインしているかどうかを確認する。
    def action_check
        puts params[:user_id]
        # ログインしていなかったらエラーをjsonで返す。
        if params[:user_id] == nil
            render json: { message: "ログインしてください。"}, status: :unauthorized 
        end
    end
end
