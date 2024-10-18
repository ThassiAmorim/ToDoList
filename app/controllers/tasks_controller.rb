class TasksController < ApplicationController
  before_action :set_task, only: [:destroy]

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
      redirect_to todo_path(@task.todo_id)
    else
      redirect_to root_path
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to todo_path(@task.todo) }
      format.js
    end
  end

  private

    def task_params
      params.require(:task).permit(:title, :done, :todo_id)
    end


    def set_task
      @task = Task.find(params[:id])
    end

end
