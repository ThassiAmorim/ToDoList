class TasksController < ApplicationController

  def create
    @task = Task.create(task_params)


    if @task.save
      redirect_to todo_path(@task.todo_id)
    else
      redirect_to root_path
    end

  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to todo_path(@task.todo_id) }
        format.js   # Isso vai renderizar um arquivo .js.erb
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js   # Para renderizar erros, se necessário
      end
    end
  end

  private

    def task_params
      params.require(:task).permit(:title, :done, :todo_id)
    end

end
