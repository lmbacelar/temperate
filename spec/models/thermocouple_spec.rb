require 'spec_helper'

describe Thermocouple do

  let (:tc) { Thermocouple.new(name: 'tc1') }

  it "remembers tc's" do
    tc.save
    expect { Thermocouple.find_by_name!('tc1') }.to_not raise_error ActiveRecord::RecordInvalid  
  end

  it 'should have a unique name' do
    tc.save
    expect { Thermocouple.create!(name: tc.name) }.to raise_error ActiveRecord::RecordInvalid
  end

  it "should have 'k' as its default kind" do
    tc.kind.should == 'k'
  end

  it "should have a valid, non empty kind" do
    [:b, :c, :e, :j, :k, :n, :r, :s, :t].each do |kind|
      tc.update_attributes(kind: kind)
      expect { tc.save! }.not_to raise_error ActiveRecord::RecordInvalid
    end
    tc.update_attributes(kind: 'x')
    expect { tc.save! }.to raise_error ActiveRecord::RecordInvalid
    tc.update_attributes(kind: nil)
    expect { tc.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  [:a3, :a2, :a1, :a0].each do |k|
    it "should have a numeric, non empty #{k}" do
      tc.update_attributes(kind: :k, k => nil)
      expect { tc.save! }.to raise_error ActiveRecord::RecordInvalid
      tc.update_attributes(k => 'a')
      expect { tc.save! }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  it "should have correction constants default to zero" do
    tc.a3.should == 0.0e+00
    tc.a2.should == 0.0e+00
    tc.a1.should == 0.0e+00
    tc.a0.should == 0.0e+00
  end
end
