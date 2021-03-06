class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)
    # @tasks = current_user.tasks
    # @tasks = Task.all
  end

  def show
    # @task = current_user.tasks.find(params[:id])
    # @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    # @task = current_user.tasks.find(params[:id])
    # @task = Task.find(params[:id])
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def create
    @task = current_user.tasks.new(task_params)
    
    if params[:back].present?
      render :new
      return
    end
    # @task = Task.new(task_params)
    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
    # task = Task.new(task_params)
    # task.save!
    # redirect_to tasks_url, notice: "タスク「#{task.name}」を登録しました。"
  end
  
  def update
    # @task = current_user.tasks.find(params[:id])
    # @task = Task.find(params[:id])
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    # @task = current_user.tasks.find(params[:id])
    # @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end
  
  private

  def task_params
    params.require(:task).permit(:name, :description, :image)
  end
  
  def set_task
    @task = current_user.tasks.find(params[:id])
  end

end
