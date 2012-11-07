require_relative '../../app/services/its90'

describe Its90 do
  context 'reference funtions' do
    examples = [ { point: 'e-H2 Tp', t90: -259.3467, wr: 0.00119007 }, 
                 { point: 'Ne Tp',   t90: -248.5939, wr: 0.00844974 }, 
                 { point: 'O2 Tp',   t90: -218.7916, wr: 0.09171804 }, 
                 { point: 'Ar Tp',   t90: -189.3442, wr: 0.21585975 }, 
                 { point: 'Hg Tp',   t90:  -38.8344, wr: 0.84414211 }, 
                 { point: 'H2O Tp',  t90:    0.01,   wr: 1.00000000 }, 
                 { point: 'Ga Mp',   t90:   29.7646, wr: 1.11813889 }, 
                 { point: 'In Fp',   t90:  156.5985, wr: 1.60980185 }, 
                 { point: 'Sn Fp',   t90:  231.9280, wr: 1.89279768 }, 
                 { point: 'Zn Fp',   t90:  419.5270, wr: 2.56891730 }, 
                 { point: 'Al Fp',   t90:  660.3230, wr: 3.37600860 }, 
                 { point: 'Ag Fp',   t90:  961.7800, wr: 4.28642053 } ] 

    context 'wr computation' do
      examples.each do |ex|
        it "handles #{ex[:point]} fixed point" do
          Its90.wr(ex[:t90]).should be_within(0.00000001).of(ex[:wr])
        end
      end

      it 'raises error when out of range' do
        expect { Its90.wr(-259.50) }.to raise_error(RangeError)
        expect { Its90.wr( 961.90) }.to raise_error(RangeError)
      end
    end

    context 't90 computation' do
      examples.each do |ex|
        it "handles #{ex[:point]} fixed point" do
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

      examples = [ {t90: -189.3442, wdev: 0.000111482},
                   {t90: -100.0000, wdev: 0.000053258},
                   {t90:  -38.8344, wdev: 0.000019889},
                   {t90:    0.0000, wdev: 0.000000005} ]
      examples.each do |ex|
        it "complies with NIST SP250-81 sample on range 4, #{ex[:t90]} Celsius" do
          sprt = stub(range: 4, a: -1.2579994e-04, b: 1.0678395e-05)
          Its90.wdev(sprt, ex[:t90]).should be_within(0.00000001).of(ex[:wdev])
        end
      end
      
      examples = [ {t90:   0.000, wdev:  0.000000007},
                   {t90: 100.000, wdev: -0.000065852},
                   {t90: 231.928, wdev: -0.000152378},
                   {t90: 419.527, wdev: -0.000271813},
                   {t90: 660.323, wdev: -0.000413567} ]
      examples.each do |ex|
        it "complies with NIST SP250-81 sample on range 6, #{ex[:t90]} Celsius" do
          sprt = stub(range: 6, a: -1.6462789e-04, b: -8.4598339e-06, c: 1.8898584e-06)
          Its90.wdev(sprt, ex[:t90]).should be_within(0.00000001).of(ex[:wdev])
        end
      end
    end
  end

  context 'temperature computation' do
    examples = [ { r: 25.7225741428, t:   0.000 },
                 { r: 35.8254370135, t: 100.000 },
                 { r: 86.8058318732, t: 660.000 } ]
    examples.each do |ex|
      it "complies with NIST SP250-81 sample on range 6, 0.000 Celsius" do
        sprt = stub(range: 6, rtpw: 25.72336, a: -1.6462789e-04, b: -8.4598339e-06, c: 1.8898584e-06)
        Its90.t90(sprt, ex[:r]).should be_within(0.001).of(ex[:t])
      end
    end
  end
end
