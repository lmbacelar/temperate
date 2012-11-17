require_relative '../../app/services/its90'
require 'json'

fp_examples  = JSON.parse(File.read('spec/assets/services/its90/fp_examples.json') , symbolize_names: true)
r4_examples  = JSON.parse(File.read('spec/assets/services/its90/r4_examples.json') , symbolize_names: true)
r6_examples  = JSON.parse(File.read('spec/assets/services/its90/r6_examples.json') , symbolize_names: true)
t90_examples = JSON.parse(File.read('spec/assets/services/its90/t90_examples.json'), symbolize_names: true)

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
      (1..11).each do |range|
        it "returns 0.0 on range #{range} for ideal SPRT" do
          sprt = stub(range: range, 
                      rtpw: 25.0, 
                      a: 0.0, b: 0.0, c: 0.0, d: 0.0, w660: 0.0, 
                      c1: 0.0, c2: 0.0, c3: 0.0, c4: 0.0, c5: 0.0)
          Its90.wdev(sprt, 0.0).should == 0.0
        end
      end

      r4_examples.each do |ex|
        it "complies with NIST SP250-81 sample on range 4, #{ex[:t90]} Celsius" do
          sprt = stub(range: 4, a: -1.2579994e-04, b: 1.0678395e-05)
          Its90.wdev(sprt, ex[:t90]).should be_within(0.00000001).of(ex[:wdev])
        end
      end
      
      r6_examples.each do |ex|
        it "complies with NIST SP250-81 sample on range 6, #{ex[:t90]} Celsius" do
          sprt = stub(range: 6, a: -1.6462789e-04, b: -8.4598339e-06, c: 1.8898584e-06)
          Its90.wdev(sprt, ex[:t90]).should be_within(0.00000001).of(ex[:wdev])
        end
      end
    end
  end

  context 'temperature function' do
    t90_examples.each do |ex|
      it "complies with IPQ cert. 501.20/1241312 range 7, #{ex[:t]} Celsius" do
        sprt = stub(range: 7, rtpw: 25.319871, a: -1.2134e-04, b: -9.9190e-06)
        Its90.t90(sprt, ex[:res]).should be_within(0.0001).of(ex[:t90])
      end
    end
  end
end
