class QuestionsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  def index
    @questions = Question.all
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @questions }
    end
  end

  def show
    @question = Question.find(params[:id])
    @users = User.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @question }
    end
  end

  def new
    @question = Question.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @question }
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    @question = current_user.questions.new(params[:question])
      if @question.save
        redirect_to root_path, :flash => { :success => "Question created!" }
      else
       render 'pages/home'
      end
  end

  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, :notice => 'Question was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :ok }
    end
  end
end
