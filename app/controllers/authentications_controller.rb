class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication= Authentication.find_by_provider_and_uid(omniauth['provider'],omniauth['uid'])
    if authentication
      flash[:notice]= "Signed in with " + omniauth['provider'] + " Successfully"
      sign_in(authentication.user)
      redirect_back_or authentication.user
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'],:uid => omniauth['uid'])
      flash[:notice]="authentication successfull"
      #redirect_back_or authentication.user
      redirect_to authentications_url
    else

   #authenticate= Authentication.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
   flash[:notice] = "You still need to fill up the following"
   # This is where I have doubt as to how should I proceed. Should I first create authentication for omniauth and then redirect or just send everything together and then create in sign up?
   # session[:omniauth] = omniauth.except('extra')
     redirect_to signup_path
   #redirect_to root_url
 end
end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end