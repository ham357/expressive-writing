class TopController < ApplicationController
  def index
    @todo  = Todo.new
    @todos = Todo.all
  end
end
