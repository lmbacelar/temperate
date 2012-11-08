require_relative '../../app/services/iec60751'

describe Iec60751 do
  let(:rtd) { stub(r0: 100.0, a: 3.9083e-03, b: -5.775e-07, c: -4.1830e-12) }
  examples = [ { r:  18.5201, t: -200.0000 }, 
               { r:  60.2558, t: -100.0000 }, 
               { r: 100.0000, t:    0.0000 }, 
               { r: 247.0920, t:  400.0000 }, 
               { r: 390.4811, t:  850.0000 } ]
  context 'temperature computation' do
    examples.each do |ex|
      it "yields #{ex[:t]} Celius when resistance equals #{ex[:r]} Ohm" do
        Iec60751.temperature(rtd, ex[:r]).should be_within(0.0001).of(ex[:t])
      end
    end

    it 'raises error when out of range' do
      expect { Iec60751.temperature(rtd,  18.00) }.to raise_error(RangeError)
      expect { Iec60751.temperature(rtd, 391.00) }.to raise_error(RangeError)
    end
  end

  context 'resistance computation' do
    examples.each do |ex|
      it "yields #{ex[:r]} Ohm when temperature equals #{ex[:t]} Celsius" do
        Iec60751.resistance(rtd, ex[:t]).should be_within(0.0001).of(ex[:r])
      end
    end

    it 'raises error when out of range' do
      expect { Iec60751.resistance(rtd, -201.00) }.to raise_error(RangeError)
      expect { Iec60751.resistance(rtd,  851.00) }.to raise_error(RangeError)
    end
  end
end
