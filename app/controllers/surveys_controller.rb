require 'twilio-ruby'

class SurveysController < ApiController
  include SurveyFinder
  before_filter :find_and_authorize_survey!, :only => [:show, :update, :destroy]

  def index
    @surveys = Survey.active.owned_by(current_customer)
    respond_with @surveys
  end

  def show
    respond_with @survey
  end

  def new
    @survey = Survey.new(:customer => current_customer)
    respond_with @survey
  end

  def create
    @survey = Survey.new(params[:survey])
    @survey.customer = current_customer
    @survey.save
    respond_with @survey
  end

  def update
    @survey.update_attributes(params[:survey])
    respond_with @survey
  end

  def destroy
    @survey.destroy
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def start
    @survey = Survey.find(params[:id])
    return unless params[:phone_number]
    @client = Twilio::REST::Client.new Ask::Config['twilio']['sid'], Ask::Config['twilio']['token']
    @client.account.sms.messages.create(
      :from => "+17032913327",
      :to => "+1#{params[:phone_number]}",
      :body => @survey.questions.first.text
    )
    respond_to do |format|
      format.json { head :ok }
    end
  end

  private

  def survey_id_params_key
    :id
  end
end
