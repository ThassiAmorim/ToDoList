class Todo < ApplicationRecord
  has_many :tasks, dependent: :destroy

  def num_tasks
    tasks.count
  end

  def progresso
    return 0 if tasks.count.zero? # evitar divisão por zero
    (tasks.where(done: true).count.to_f / tasks.count * 100).round(2)
  end

end
