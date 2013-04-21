require_relative "spec_helper"

describe Mirror::Api::Timeline do

  def auth_params
    {
        :token => "my-token"
    }
  end

 describe "inserting" do
   it "should insert plain text items" do
     api = Mirror::Api::Timeline.new(auth_params)

     item = api.post({:text => "Hello World"})

     item.should_not be_nil
     item.created_at.should > 10.minutes.ago
     item.text.should == "Hello World"
   end
 end
end