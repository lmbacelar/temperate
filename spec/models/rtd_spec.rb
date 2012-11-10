require 'spec_helper'

describe Rtd do

  let (:rtd) { Rtd.new(name: 'rtd1') }

  it "remembers rtd's" do
    rtd.save
    expect { Rtd.find_by_name!('rtd1') }.to_not raise_error ActiveRecord::RecordInvalid  
  end

  it 'should have a unique name' do
    rtd.save
    expect { Rtd.create!(name: rtd.name) }.to raise_error ActiveRecord::RecordInvalid
  end

  [:r0, :a, :b, :c].each do |k|
    it "should have a numeric, non empty #{k}" do
      rtd.update_attributes(k => nil)
      expect { rtd.save! }.to raise_error ActiveRecord::RecordInvalid
      rtd.update_attributes(k => 'a')
      expect { rtd.save! }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  it 'should have default constants according to IEC60751' do
    rtd.r0.should == 100.0
    rtd.a.should  ==   3.9083e-03
    rtd.b.should  ==  -5.7750e-07
    rtd.c.should  ==  -4.1830e-12
  end
end
