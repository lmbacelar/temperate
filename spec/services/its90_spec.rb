require_relative '../../app/services/its90'
require 'json'

fp_examples  = JSON.parse(File.read('spec/assets/services/its90/fp_examples.json') , symbolize_names: true)
r4_examples  = JSON.parse(File.read('spec/assets/services/its90/r4_examples.json') , symbolize_names: true)
r4_sprt      = JSON.parse(File.read('spec/assets/services/its90/r4_sprt.json')     , symbolize_names: true)
r6_examples  = JSON.parse(File.read('spec/assets/services/its90/r6_examples.json') , symbolize_names: true)
r6_sprt      = JSON.parse(File.read('spec/assets/services/its90/r6_sprt.json')     , symbolize_names: true)
t90_examples = JSON.parse(File.read('spec/assets/services/its90/t90_examples.json'), symbolize_names: true)
ipq_sprt     = JSON.parse(File.read('spec/assets/services/its90/ipq_sprt.json')    , symbolize_names: true)

describe Its90 do
  context 'reference funtions' do
    context 'wr computation' do
      fp_examples.each do |ex|
        it "complies on #{ex[:point]} fixed point" do
          Its90.wr(ex[:t90]).should be_within(0.00000001).of(ex[:wr])
        end
      end

      it 'raises error when out of range' do
        expect { Its90.wr(-259.50) }.to raise_error(RangeError)
        expect { Its90.wr( 961.90) }.to raise_error(RangeError)
      end
    end

    context 't90r computation' do
      fp_examples.each do |ex|
        it "complies on #{ex[:point]} fixed point" do
          Its90.t90r(ex[:wr]).should be_within(0.00013).of(ex[:t90])
        end
      end

      it 'raises error when out of range' do
        expect { Its90.t90r(0.001) }.to raise_error(RangeError)
        expect { Its90.t90r(4.290) }.to raise_error(RangeError)
      end
    end
  end

  context 'deviation functions' do
    context 'wdev computation' do
      it 'defaults all coefficients to 0.0' do
        Its90.wdev(0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0).should == Its90.wdev(0.0, 1)
        Its90.wdev(0.0, 5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0).should == Its90.wdev(0.0, 5)
      end

      r4_examples.each do |ex|
        it "complies with NIST SP250-81 sample on range 4, #{ex[:t90]} Celsius" do
          Its90.wdev(ex[:t90], 4, r4_sprt[:a], r4_sprt[:b]).should be_within(0.00000001).of(ex[:wdev])
        end
      end
      
      r6_examples.each do |ex|
        it "complies with NIST SP250-81 sample on range 6, #{ex[:t90]} Celsius" do
          Its90.wdev(ex[:t90], 6, r6_sprt[:a], r6_sprt[:b], r6_sprt[:c]).should be_within(0.00000001).of(ex[:wdev])
        end
      end
    end
  end

  context 'temperature function' do
    it 'defaults rtpw to 25.0 Ohm, all other coefficients to 0.0' do
      Its90.t90(10.0, 1, 25.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0).should == Its90.t90(10.0, 1)
      Its90.t90(30.0, 5, 25.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0).should == Its90.t90(30.0, 5)
    end

    t90_examples.each do |ex|
      it "complies with IPQ cert. 501.20/1241312 range 7, #{ex[:t90]} Celsius" do
        Its90.t90(ex[:res], 7, ipq_sprt[:rtpw], ipq_sprt[:a], ipq_sprt[:b]).should be_within(0.0001).of(ex[:t90])
      end
    end
  end
end
