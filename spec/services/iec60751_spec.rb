require_relative '../../app/services/iec60751'
require 'json'

std_examples     = JSON.parse(File.read('spec/assets/services/iec60751/std_examples.json'),     symbolize_names: true)
non_std_rtd      = JSON.parse(File.read('spec/assets/services/iec60751/non_std_rtd.json'),      symbolize_names: true)
non_std_examples = JSON.parse(File.read('spec/assets/services/iec60751/non_std_examples.json'), symbolize_names: true)

describe Iec60751 do
  context 't90 computation' do
    context 'on a standard rtd' do
      std_examples.each do |ex|
        it "yields #{ex[:t90]} Celius when resistance equals #{ex[:res]} Ohm" do
          Iec60751.t90(ex[:res]).should be_within(0.0001).of(ex[:t90])
        end
      end
    end

    context "on a non-standard rtd having R0=#{non_std_rtd[:r0]}, A=#{non_std_rtd[:a]}, B=#{non_std_rtd[:b]}, C=#{non_std_rtd[:c]}" do
      non_std_examples.each do |ex|
        it "yields #{ex[:t90]} Celius when resistance equals #{ex[:res]} Ohm" do
          Iec60751.t90(ex[:res],  non_std_rtd[:r0], 
                                  non_std_rtd[:a], 
                                  non_std_rtd[:b], 
                                  non_std_rtd[:c]).should be_within(0.0001).of(ex[:t90])
        end
      end
    end

    it 'raises error when out of range' do
      expect { Iec60751.t90( 18.00) }.to raise_error(RangeError)
      expect { Iec60751.t90(391.00) }.to raise_error(RangeError)
    end
  end

  context 'resistance computation' do
    context 'on a standard rtd' do
      std_examples.each do |ex|
        it "yields #{ex[:res]} Ohm when t90 equals #{ex[:t90]} Celsius" do
          Iec60751.res(ex[:t90]).should be_within(0.0001).of(ex[:res])
        end
      end
    end

    context "on a non-standard rtd having R0=#{non_std_rtd[:r0]}, A=#{non_std_rtd[:a]}, B=#{non_std_rtd[:b]}, C=#{non_std_rtd[:c]}" do
      non_std_examples.each do |ex|
        it "yields #{ex[:res]} Ohm when t90 equals #{ex[:t90]} Celsius" do
          Iec60751.res(ex[:t90],  non_std_rtd[:r0], 
                                  non_std_rtd[:a],
                                  non_std_rtd[:b],
                                  non_std_rtd[:c]).should be_within(0.0001).of(ex[:res])
        end
      end
    end

    it 'raises error when out of range' do
      expect { Iec60751.res(-201.00) }.to raise_error(RangeError)
      expect { Iec60751.res( 851.00) }.to raise_error(RangeError)
    end
  end
end
