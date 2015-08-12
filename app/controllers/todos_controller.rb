class TodosController < ApplicationController
  def index
    render json: session[:todos].to_a
  end

  def create
    session[:todos] = params[:todos]
    render nothing: true
  end
end
