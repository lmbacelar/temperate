require_relative '../../app/services/unit_conversion.rb'

describe UnitConversion do
  context 'conversions' do
    let(:uc) { UnitConversion.new(:temperature) }

    examples = [ { delta: false, data: [ { celsius: -273.15, kelvin:    0.00, fahrenheit: -459.67, rankine:    0.00 }, 
                                         { celsius:    0.00, kelvin:  273.15, fahrenheit:   32.00, rankine:  491.67 },
                                         { celsius: 2320.00, kelvin: 2593.15, fahrenheit: 4208.00, rankine: 4667.67 } ] },
                 { delta: true,  data: [ { celsius:   -1.00, kelvin:   -1.00, fahrenheit:   -1.80, rankine:   -1.80 },
                                         { celsius:    0.00, kelvin:    0.00, fahrenheit:    0.00, rankine:    0.00 },
                                         { celsius:    1.00, kelvin:    1.00, fahrenheit:    1.80, rankine:    1.80 } ] } ]
    examples.each do |ex|
      context ex[:delta] ? 'relative' : 'absolute' do
        ex[:data].each do |dt|
          context "(#{dt[:celsius] < 0 ? 'negative' : dt[:celsius] == 0 ? 'zero' : 'positive'}#{ex[:delta] ? '' : ' celsius'})" do
            dt.each do |to, expected|
              dt.each do |from, temp|
                it "handles #{from} to #{to}" do
                  uc.convert(temp, from, to, ex[:delta]).should be_within(0.0001).of(expected)
                end
              end
            end
          end
        end
      end
    end

    context 'error checks' do
      it 'raises error when missing parameters' do
        expect { uc.convert                                 }.to raise_error(ArgumentError)
        expect { uc.convert(t:    0.00)                     }.to raise_error(ArgumentError)
        expect { uc.convert(from: :celsius)                 }.to raise_error(ArgumentError)
        expect { uc.convert(to:   :celsius)                 }.to raise_error(ArgumentError)
        expect { uc.convert(t:    0.00,     from: :celsius) }.to raise_error(ArgumentError)
        expect { uc.convert(t:    0.00,     to:   :celsius) }.to raise_error(ArgumentError)
        expect { uc.convert(from: :celsius, to:   :celsius) }.to raise_error(ArgumentError)
      end

      it 'raises error when wrong parameters' do
        expect { uc.convert(t: 0.00, from: :celsius, to: :dummy1 ) }.to raise_error(ArgumentError)
        expect { uc.convert(t: 0.00, from: :dummy1,  to: :celsius) }.to raise_error(ArgumentError)
        expect { uc.convert(t: 0.00, from: :dummy1,  to: :dummy1 ) }.to raise_error(ArgumentError)
        expect { uc.convert(t: 0.00, from: :dummy1,  to: :dummy2 ) }.to raise_error(ArgumentError)
      end

      it 'raises error when t is out of range' do
        expect { uc.convert(-1.00, :kelvin,  :kelvin )}.to raise_error(RangeError)
        expect { uc.convert(-274.00, :celsius, :rankine)}.to raise_error(RangeError)
      end
    end
  end
end
