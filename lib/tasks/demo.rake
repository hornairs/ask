Bundler.setup(:test)

namespace :demo do
  desc "Installs some random data"
  task :install => [:environment, 'db:reset'] do
    customer = Customer.create!(email: "harry.brundage@gmail.com", password: "password", password_confirmation: 'password')
    2.times do
      survey = FactoryGirl.create(:survey_with_one_rating_question)
      1.upto(30) do |i|
        Timecop.travel(Time.now - i.days) do
          (rand(20) + 10).times do
            response = FactoryGirl.create(:response, :survey => survey)
            if rand(2) == 1
              response.step!("#{rand(4) + 1}") # Answer the rating
            else
              response.step!("#{"*" * (rand(4) + 1)}") # Answer the rating
            end

            while response.step!(FactoryGirl.generate(:answer_text))
              true
            end
          end
        end
      end
    end
  end
end
