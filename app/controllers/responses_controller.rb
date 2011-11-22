class ResponsesController < ApplicationController
  respond_to :json

  def index
    @responses = Survey.find(params[:survey_id]).responses
    .order('id DESC')
    .offset(params[:offset] || 0)
    .limit(params[:limit] || 25)
    .includes([
      {:survey => :questions},
      :responder,
      {:answers => [:question, :rating]}
    ])

    respond_with @responses
  end

  def show
    @response = Response.find(params[:id])
    respond_with @response
  end

  def destroy
    @response = Response.find(params[:id])
    @response.destroy
    respond_to do |format|
      format.json { head :ok }
    end
  end
end
