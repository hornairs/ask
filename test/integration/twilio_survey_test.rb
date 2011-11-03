require 'test_helper'

class TwilioSurveyTest < ActionDispatch::IntegrationTest
  setup do
    @responder = Factory.create(:responder)
  end
  test "should allow the first question to be answered" do
    @survey = Factory.create(:survey_with_many_questions)

    assert_difference('Response.count') do
      assert_difference('Answer.count') do
        post "/api/twilio/receive/#{@survey.phone_number}.xml", {:From => @responder.phone_number, :Body => "Yes"}
      end
    end

    assert_response :success
  end

  test "should allow the last question to be answered" do
    @survey = Factory.create(:survey_with_one_question)

    assert_difference('Response.count') do
      assert_difference('Answer.count') do
        post "/api/twilio/receive/#{@survey.phone_number}.xml", {:From => @responder.phone_number, :Body => "Yes"}
      end
    end
    assert_redirected_to :action => :finished, :format => :xml
  end

  test "should error if the user tries to answer more than the available questions" do
    @survey = Factory.create(:survey_with_one_question)

    post "/api/twilio/receive/#{@survey.phone_number}.xml", {:From => @responder.phone_number, :Body => "Yes"}
    assert_redirected_to :action => :finished, :format => :xml
    post "/api/twilio/receive/#{@survey.phone_number}.xml", {:From => @responder.phone_number, :Body => "No"}
    assert_redirected_to :action => :error, :format => :xml, :message => "Sorry, you've already answered all the questions. Thanks for responding!"
  end

  test "should error if the user tries to answer a non existant survey" do
    post "/api/twilio/receive/404.xml", {:From => @responder.phone_number, :Body => "Yes"}
    assert_redirected_to :action => :error, :format => :xml, :message => "Sorry, the survey you're trying to fill out can't be found."
  end
end
