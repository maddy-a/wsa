class AnswersController < ApplicationController
  
  def new
    @answer = Answer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @answer }
    end
  end
  
  def create
   @question = Question.find(params[:question_id])
   @answer = @question.answers.create!(params[:answer])
   @answer.user_id = current_user.id
  
   respond_to do |format|
      if @answer.save
        format.html { redirect_to @question, :notice => 'Answer was successfully created.' }
        #format.json { render :json => @question, :status => :created, :location => @question }
        format.js # create.js.erb
      else
        format.html { render :action => "new" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
     @answer = Answer.find(params[:id])
   end
   
  def update
     @answer = Answer.find(params[:id])

     respond_to do |format|
       if @answer.update_attributes(params[:answer])
         format.html { redirect_to @question, :notice => 'Question was successfully updated.' }
         format.json { head :ok }
       else
         format.html { render :action => "edit" }
         format.json { render :json => @question.errors, :status => :unprocessable_entity }
       end
     end
   end

   def destroy
     @answer = Answer.find(params[:id])
     @answer.destroy

     respond_to do |format|
       format.html { redirect_to questions_url }
       format.json { head :ok }
     end
   end
 
end
