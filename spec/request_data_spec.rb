require "spec_helper"

describe Mirror::Api::RequestData do

  describe "initialize" do
    it 'should should convert keys to camelCase' do
      data = Mirror::Api::RequestData.new(:text => "abc", :menu_items => ["ABC"])
      data.should_not be_nil
      data.text.should == "abc"
      data.menu_items.should == ["ABC"]
      data.menuItems.should == ["ABC"]
    end
  end

  describe "to_json" do
    it "should only pass the camelCase" do
      data = Mirror::Api::RequestData.new(:text => "abc", :menu_items => ["ABC"])
      json = data.to_json
      JSON.parse(json).should == {"text"=>"abc", "menuItems"=>["ABC"]}
    end
  end

  describe "updates" do
    it "should support changes" do
      data = Mirror::Api::RequestData.new(:text => "abc", :menu_items => ["ABC"])
      data.menu_items = ["DEF"]
      json = data.to_json
      JSON.parse(json).should == {"text"=>"abc", "menuItems"=>["DEF"]}
    end

    it "should support appending" do
      data = Mirror::Api::RequestData.new(:text => "abc", :menu_items => ["ABC"])
      data.menu_items << "DEF"
      json = data.to_json
      JSON.parse(json).should == {"text"=>"abc", "menuItems"=>["ABC", "DEF"]}
    end
  end
end