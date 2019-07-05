class TodosController < ApplicationController
  def create
    todo = params.require(:todo).permit(:description)
    Todo.create(todo)
    redirect_to :root
  end
end
