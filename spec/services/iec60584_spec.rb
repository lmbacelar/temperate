require_relative '../../app/services/iec60584'

describe Iec60584 do
  examples = { b: [ { e:  0.000, t:     0.0 },
                    { e:  0.291, t:   250.0 },
                    { e:  1.975, t:   630.0 },
                    { e:  1.981, t:   631.0 },
                    { e:  5.780, t:  1100.0 },
                    { e: 13.820, t:  1820.0 } ], 
               c: [ { e:  0.000, t:     0.0 },
                    { e:  1.451, t:   100.0 },
                    { e: 11.778, t:   660.0 },
                    { e: 20.066, t:  1100.0 },
                    { e: 29.402, t:  1680.0 },
                    { e: 37.107, t:  2320.0 } ], 
               e: [ { e: -9.835, t:  -270.0 },
                    { e: -5.237, t:  -100.0 },
                    { e:  0.000, t:     0.0 },
                    { e:  6.319, t:   100.0 },
                    { e: 49.917, t:   660.0 },
                    { e: 76.373, t:  1000.0 } ], 
               j: [ { e: -8.095, t:  -210.0 }, 
                    { e: -4.633, t:  -100.0 }, 
                    { e:  0.000, t:     0.0 }, 
                    { e: 36.675, t:   660.0 }, 
                    { e: 43.559, t:   770.0 }, 
                    { e: 69.553, t:  1200.0 } ],
               k: [ { e: -6.458, t:  -270.0 }, 
                    { e: -3.554, t:  -100.0 }, 
                    { e:  0.000, t:     0.0 }, 
                    { e:  5.206, t:   127.0 }, 
                    { e: 27.447, t:   660.0 }, 
                    { e: 54.886, t:  1372.0 } ],
               n: [ { e: -4.345, t:  -270.0 },
                    { e: -2.407, t:  -100.0 },
                    { e:  0.000, t:     0.0 },
                    { e:  2.774, t:   100.0 },
                    { e: 22.958, t:   660.0 },
                    { e: 47.513, t:  1300.0 } ], 
               r: [ { e: -0.226, t:   -50.0 },
                    { e: -0.123, t:   -25.0 },
                    { e:  0.000, t:     0.0 },
                    { e:  6.273, t:   660.0 },
                    { e: 11.850, t:  1100.0 },
                    { e: 21.101, t:  1768.0 } ],
               s: [ { e: -0.236, t:   -50.0 },
                    { e: -0.127, t:   -25.0 },
                    { e:  0.000, t:     0.0 },
                    { e:  5.857, t:   660.0 },
                    { e: 10.757, t:  1100.0 },
                    { e: 18.693, t:  1768.0 } ],
               t: [ { e: -6.258, t:  -270.0 },
                    { e: -3.379, t:  -100.0 },
                    { e:  0.000, t:     0.0 },
                    { e:  4.279, t:   100.0 },
                    { e:  9.288, t:   200.0 },
                    { e: 20.872, t:   400.0 } ]
             }
  context 'temperature computation' do
    [:b].each do |kind|
      context "on a type #{kind} thermocouple" do
        let(:tc) { stub(kind: kind, a3: 0.0, a2: 0.0, a1: 0.0, a0: 0.0) }
        examples[kind].each do |ex|
          it "should be reciprocal of emf for #{ex[:t]} Celsius" do
            Iec60584.temperature(tc, Iec60584.emf(tc, ex[:t])).should be_within(0.001).of(ex[:t])
          end
        end

        #it 'raises error when out of range' do
        #  expect { Iec60584.temperature(tc,  18.00) }.to raise_error(RangeError)
        #  expect { Iec60584.temperature(tc, 391.00) }.to raise_error(RangeError)
        #end
      end
    end
  end

  context 'emf computation' do
    [:b, :c, :e, :j, :k, :n, :r, :s, :t].each do |kind|
      context "on a type #{kind} thermocouple" do
        let(:tc) { stub(kind: kind, a3: 0.0, a2: 0.0, a1: 0.0, a0: 0.0) }
        examples[kind].each do |ex|
          it "yields #{ex[:e]} mV when temperature equals #{ex[:t]} Celsius" do
            Iec60584.emf(tc, ex[:t]).should be_within(0.001).of(ex[:e])
          end
        end

        it 'raises error when out of range' do
          expect { Iec60584.emf(tc, examples[kind].first[:t] - 1.0) }.to raise_error(RangeError)
          expect { Iec60584.emf(tc, examples[kind].last[:t]  + 1.0) }.to raise_error(RangeError)
        end
      end
    end
  end
end
