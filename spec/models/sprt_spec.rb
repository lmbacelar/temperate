require 'spec_helper'

describe Sprt do

  let (:sprt) { Sprt.new(name: 'sprt1') }

  it "remembers sprt's" do
    sprt.save
    expect { Sprt.find_by_name!('sprt1') }.to_not raise_error ActiveRecord::RecordInvalid  
  end

  it 'should have a unique name non empty' do
    sprt.save
    expect { Sprt.create!(name: sprt.name) }.to raise_error ActiveRecord::RecordInvalid
    expect { Sprt.create!(name: nil)       }.to raise_error ActiveRecord::RecordInvalid
    expect { Sprt.create!(name: '')        }.to raise_error ActiveRecord::RecordInvalid
  end

  [:range, :rtpw, :a, :b, :c, :d, :w660, :c1, :c2, :c3, :c4, :c5].each do |k|
    it "should have a numeric, non empty #{k}" do
      sprt.update_attributes(k => nil)
      expect { sprt.save! }.to raise_error ActiveRecord::RecordInvalid
      sprt.update_attributes(k => 'a')
      expect { sprt.save! }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  it 'should have default constants according to ITS-90' do
    sprt.range.should == 11
    sprt.rtpw.should  == 25.0
    [:a, :b, :c, :d, :w660, :c1, :c2, :c3, :c4, :c5].each do |k|
      sprt.send(k).should == 0.0
    end
  end
end
