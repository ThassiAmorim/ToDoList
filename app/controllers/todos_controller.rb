class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all
  end

  def home
    @todos = Todo.includes(:tasks)
  end

  # GET /todos/1 or /todos/1.json
  def show
    @task = Task.new
    @tasks = @todo.tasks
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo}
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to todos_path, status: :see_other}
      format.json { head :no_content }
    end
  end


  def dashboard
    @todos = Todo.includes(:tasks)

    @tasks_by_todo = @todos.each_with_object({}) do |todo, hash|
      hash[todo.id] = todo.num_tasks
    end

    @progress_by_todo = @todos.each_with_object({}) do |todo, hash|
      hash[todo.id] = todo.progresso
    end

    # convertendo os dados para um formato adequado para o JavaScript
    @todos_data = @todos.map do |todo|
      {
        id: todo.id,
        name: todo.name, 
        num_tasks: todo.num_tasks,
        progress: todo.progresso
      }
    end.to_json

    Rails.logger.debug "Todos data: #{@todos_data.inspect}"
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:name)
    end
end
