require_relative '../../app/services/iec60584'
require 'json'

temp_examples = JSON.parse(File.read('spec/assets/iec60584_temp_examples.json'), symbolize_names: true)
emf_examples  = JSON.parse(File.read('spec/assets/iec60584_emf_examples.json'),  symbolize_names: true)

describe Iec60584 do
  context 'temperature computation' do
    [:b, :e, :j, :k, :n, :r, :s, :t].each do |kind|
      context "on a type #{kind} thermocouple" do
        let(:tc) { stub(kind: kind, a3: 0.0, a2: 0.0, a1: 0.0, a0: 0.0) }
        temp_examples[kind].each do |ex|
          it "should be reciprocal of emf for #{ex[:t]} Celsius" do
            Iec60584.temperature(tc, Iec60584.emf(tc, ex[:t])).should be_within(0.001).of(ex[:t])
          end
        end

        it 'raises error when out of range' do
          expect { Iec60584.temperature(tc, temp_examples[kind].first[:e] - 0.002) }.to raise_error(RangeError)
          expect { Iec60584.temperature(tc, temp_examples[kind].last[:e]  + 0.002) }.to raise_error(RangeError)
        end
      end
    end
  end

  context 'emf computation' do
    [:b, :c, :e, :j, :k, :n, :r, :s, :t].each do |kind|
      context "on a type #{kind} thermocouple" do
        let(:tc) { stub(kind: kind, a3: 0.0, a2: 0.0, a1: 0.0, a0: 0.0) }
        emf_examples[kind].each do |ex|
          it "yields #{ex[:e]} mV when temperature equals #{ex[:t]} Celsius" do
            Iec60584.emf(tc, ex[:t]).should be_within(0.001).of(ex[:e])
          end
        end

        it 'raises error when out of range' do
          expect { Iec60584.emf(tc, emf_examples[kind].first[:t] - 1.0) }.to raise_error(RangeError)
          expect { Iec60584.emf(tc, emf_examples[kind].last[:t]  + 1.0) }.to raise_error(RangeError)
        end
      end
    end
  end
end
