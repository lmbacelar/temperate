require_relative '../../app/services/iec60584'
require 'json'

t90_examples = JSON.parse(File.read('spec/assets/services/iec60584/t90_examples.json'), symbolize_names: true)
emf_examples = JSON.parse(File.read('spec/assets/services/iec60584/emf_examples.json'), symbolize_names: true)

describe Iec60584 do
  context 'emf computation' do
    emf_examples.keys.each do |kind|
      context "on a type #{kind} thermocouple" do
        emf_examples[kind].each do |ex|
          it "yields #{ex[:emf]} mV when t90 equals #{ex[:t90]} Celsius" do
            Iec60584.emf(ex[:t90], kind).should be_within(0.001).of(ex[:emf])
          end
        end

        it 'raises error when out of range' do
          expect { Iec60584.emf(emf_examples[kind].first[:t90] - 1.0, kind) }.to raise_error(RangeError)
          expect { Iec60584.emf(emf_examples[kind].last[:t90]  + 1.0, kind) }.to raise_error(RangeError)
        end
      end
    end
  end

  context 't90 computation' do
    t90_examples.keys.each do |kind|
      context "on a type #{kind} thermocouple" do
        t90_examples[kind].each do |ex|
          it "should be reciprocal of emf for #{ex[:t90]} Celsius" do
            emf = Iec60584.emf(ex[:t90], kind)
            t90 = Iec60584.t90(emf, kind)
            t90.should be_within(0.001).of(ex[:t90])
          end
        end

        it 'raises error when out of range' do
          expect { Iec60584.t90(t90_examples[kind].first[:emf] - 0.002, kind) }.to raise_error(RangeError)
          expect { Iec60584.t90(t90_examples[kind].last[:emf]  + 0.002, kind) }.to raise_error(RangeError)
        end
      end
    end

    context '3rd order polynomial correction' do
      let(:a0) { 1.00e+00 }
      let(:a1) { 1.00e-03 }
      let(:a2) { 1.00e-06 }
      let(:a3) { 1.00e-09 }
      [-50.0, 0.0, 660.0, 1100].each do |t|
        it "yields correction for t90 = #{t} Celsius" do
          emf = Iec60584.emf(t, :k) # emf(t0) is equal to emf(t1)
          (Iec60584.t90(emf, :k, a0, a1, a2, a3) - Iec60584.t90(emf, :k)).should be_within(0.001).of(a3*t**3 + a2*t**2 + a1*t + a0)
        end
      end
    end
  end
end
