require 'spec_helper'

describe Iec60751Controller do
  it 'returns temperatures from resistance' do
    #Iec60751.stub(:t90).with(100.0) { 0.0 }
    get :t90, r: "100.0"
    response.body.should == { t90: 0.0 }.to_json 
  end
end
