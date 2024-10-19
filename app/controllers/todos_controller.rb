class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all

    #filtro de busca
    @query = params[:query]

    if @query.present?
      @todos = @todos.where("name ILIKE ?", "%#{@query}%")
    end

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

  def planilha
    todos = Todo.all

    p = Axlsx::Package.new
    wb = p.workbook

    center_style = wb.styles.add_style(
      alignment: { vertical: :center, horizontal: :center, wrap_text: true }
    )
    edge_style = wb.styles.add_style(
      alignment: { vertical: :center, wrap_text: true }
    )
    percent_style = wb.styles.add_style(
      format_code: '0.00%',
      alignment: { vertical: :center, horizontal: :center, wrap_text: true }
    )

    wb.add_worksheet(name: "Relatório") do |sheet|
      sheet.add_row ["Lista", "Atividades", "Concluída?", "Percentual de Conclusão"],
                    style: [center_style, center_style, center_style, center_style]

      todos.each do |todo|
        tasks = todo.tasks
        next if tasks.empty?

        tasks.each do |task|
          sheet.add_row [
            todo.name,
            task.title,
            task.done ? 'Sim' : 'Não',
            todo.progresso / 100
          ], style: [center_style, edge_style, center_style, percent_style]
        end


        sheet.merge_cells("A#{sheet.rows.size - tasks.size + 1}:A#{sheet.rows.size}")
        sheet.merge_cells("D#{sheet.rows.size - tasks.size + 1}:D#{sheet.rows.size}")
      end
    end


    send_data p.to_stream.read, filename: 'ToDo.xlsx', type: "application/xlsx"
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
