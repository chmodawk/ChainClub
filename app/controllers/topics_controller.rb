class TopicsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  def index
    @topics = Topic.all
  end
  
  def show
    @topic = Topic.find(params[:id])
    @answers = @topic.answers.paginate(:page => params[:page], :per_page => 5)
  end
    
  def new 
    @topic = Topic.new 
  end
  
  def create
    @topic = Topic.new(topic_params)
    @topic.user = current_user
    
    if @topic.save
      redirect_to topics_path
    else
      render :new  
    end
  end
  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])

    if @topic.update(topic_params)
      redirect_to topics_path, notice: "该提问已更新成功!"
    else 
      render :edit 
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
  
    redirect_to topics_path, alert: "该提问已被删除！"
  end

  private
 
  def topic_params
    params.require(:topic).permit(:title, :content)
  end  
end