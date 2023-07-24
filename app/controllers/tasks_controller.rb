class TasksController < ApplicationController
    before_action :set_task, only: %i[ show edit update destroy ]

    # GET /users/:user_id/tasks or /users/:user_id/tasks.json
    def index
        @tasks = Task.all

        respond_to do |format|
            format.json { render json: @users, status: :ok }
        end
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

        respond_to do |format|
            if @task.save
                format.json { message: "登録成功です。", status: :created }
            else
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /tasks/1 or /tasks/1.json
    def update
        respond_to do |format|
            if @task.update(task_params)
                format.json { message: "更新完了です。", status: :ok }
            else
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /tasks/1 or /tasks/1.json
    def destroy
        @task.destroy

        respond_to do |format|
            format.json { message: "削除成功です。", status: :no_content }
        end
    end

    private
        # idに対応するデータを見つける
        def set_task
            @task = Task.find(params[:id])
        end

        # 必須のtaskパラメータを取得する
        def task_params
            params.require(:task).permit(:name, :deadline, :priority, :is_complete)
        end
end
