class TasksController < ApplicationController
    before_action :function_enabled_judge, only: %i[ new create edit update destroy ]
    before_action :set_room, only: %i[ show edit update destroy ]

    # GET /rooms or /rooms.json
    def index
        @rooms = Room.all.with_attached_images
    end

    # GET /rooms/1 or /rooms/1.json
    def show
    end

    # GET /rooms/new
    def new
        @room = Room.new
    end

    # GET /rooms/1/edit
    def edit
    end

    # POST /rooms or /rooms.json
    def create
        @room = Room.new(room_params)

        respond_to do |format|
            if @room.save
                session[:room] = @room.name
                format.json { render :show, status: :created, location: @room }
            else
                format.json { render json: @room.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /rooms/1 or /rooms/1.json
    def update
        respond_to do |format|
            if @room.update(room_params)
                format.json { render :show, status: :ok, location: @room }
            else
                format.json { render json: @room.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /rooms/1 or /rooms/1.json
    def destroy
        @room.destroy

        respond_to do |format|
            format.json { head :no_content }
        end
    end

    private
        def set_room
            @room = Room.find(params[:id])
        end

        def room_params
            params.require(:room).permit(:name, :place, :number, images: [])
        end

        def function_enabled_judge
            if session[:user_id] == nil || !User.find(session[:user_id]).admin
                redirect_to root_path
            end
        end
end
