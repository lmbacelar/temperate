require_relative '../../app/services/iec60751'
require 'json'

examples = JSON.parse(File.read('spec/assets/services/iec60751/examples.json'), symbolize_names: true)

describe Iec60751 do
  let(:rtd) { stub(r0: 100.0, a: 3.9083e-03, b: -5.775e-07, c: -4.1830e-12) }
  context 't90 computation' do
    examples.each do |ex|
      it "yields #{ex[:t90]} Celius when resistance equals #{ex[:res]} Ohm" do
        Iec60751.t90(rtd, ex[:res]).should be_within(0.0001).of(ex[:t90])
      end
    end

    it 'raises error when out of range' do
      expect { Iec60751.t90(rtd,  18.00) }.to raise_error(RangeError)
      expect { Iec60751.t90(rtd, 391.00) }.to raise_error(RangeError)
    end
  end

  context 'resistance computation' do
    examples.each do |ex|
      it "yields #{ex[:res]} Ohm when t90 equals #{ex[:t90]} Celsius" do
        Iec60751.res(rtd, ex[:t90]).should be_within(0.0001).of(ex[:res])
      end
    end

    it 'raises error when out of range' do
      expect { Iec60751.res(rtd, -201.00) }.to raise_error(RangeError)
      expect { Iec60751.res(rtd,  851.00) }.to raise_error(RangeError)
    end
  end
end
