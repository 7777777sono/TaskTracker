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

        # respond_to do |format|
        #     if @task.save
        #         format.json { message: "登録成功です。", status: :created }
        #     else
        #         format.json { render json: @task.errors, status: :unprocessable_entity }
        #     end
        # end
    end

    # PATCH/PUT /tasks/1 or /tasks/1.json
    def update
        # respond_to do |format|
        #     if @task.update(task_params)
        #         format.json { message: "更新完了です。", status: :ok }
        #     else
        #         format.json { render json: @task.errors, status: :unprocessable_entity }
        #     end
        # end
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
        # ログインしていたらそのユーザが登録したタスクを格納する
        if session[:user_id] != nil
            @task = Task.find_by(user_id: session[:user_id])
        end
    end

    # 必須のtaskパラメータを取得する
    def task_params
        params.require(:task).permit(:name, :deadline, :priority, :is_complete, :user_id)
    end

    # ログインしてないとtaskは、操作できないのでログインしているかどうかを確認する。
    def action_check
        # # ログインしていなかったらエラーをjsonで返す。
        if params[:user_id] == nil
            render json: { message: "ログインしてください。"}, status: :unauthorized 
        end
    end
end
