class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def login
    if current_user.present? 
      redirect_to bets_path
    end
  end
end