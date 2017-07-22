class DivisionsController < ApplicationController
  
  def show
    @division = Division.find(params[:id])
  end
  
  def new
    @division = Division.new
  end
  
  def create
  end
  
  def edit
    @division = Division.find(params[:id])
  end
  
  def update
    @division = Division.find(params[:id])
    if @division.update_attributes(division_params)
      flash[:success] = "Settings updated"
      redirect_to @league
    else
      render 'edit'
    end
  end
  
  def destroy
    Division.find(params[:id]).destroy
    flash[:success] = "Division deleted"
    redirect_to @league
  end
  
  private
  
    def division_params
      params.require(:division).permit(:name)
    end
end