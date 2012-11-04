require_relative '../../app/services/sprt'
require_relative '../../app/services/unit'

describe SPRT do
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
          SPRT.wr(t90: ex[:t90]).should be_within(0.0000001).of(ex[:wr])
        end
      end

      it 'handles kelvin units' do
        SPRT.wr(t90: 273.16, unit: :kelvin).should be_within(0.0000001).of(1.00000000)
      end

      it 'raises error when out of range' do
        expect { SPRT.wr(t90: -259.50) }.to raise_error(RangeError, /t90.*out.*range/)
        expect { SPRT.wr(t90:  961.90) }.to raise_error(RangeError, /t90.*out.*range/)
      end

      it 'raises error when no t90 is set' do
        expect { SPRT.wr }.to raise_error
        expect { SPRT.wr(dummy: :dummy) }.to raise_error(ArgumentError, /t90.*(required|missing)/)
      end
    end

    context 't90 computation' do
      examples.each do |ex|
        it "handles #{ex[:point]} fixed point" do
          SPRT.t90(wr: ex[:wr]).should be_within(0.00013).of(ex[:t90])
        end
      end

      it 'handles kelvin units' do
        SPRT.t90(wr: 1.00000000, unit: :kelvin).should be_within(0.00013).of(273.16)
      end

      it 'raises error when out of range' do
        expect { SPRT.t90(wr: 0.001) }.to raise_error(RangeError, /t90.*out.*range/)
        expect { SPRT.t90(wr: 4.290) }.to raise_error(RangeError, /t90.*out.*range/)
      end

      it 'raises error when no wr is set' do
        expect { SPRT.t90 }.to raise_error
        expect { SPRT.t90(dummy: :dummy) }.to raise_error(ArgumentError, /wr.*(missing|required)/)
      end
    end
  end

  context 'deviation functions' do
    context 'wdev computation' do
      it 'raises error when no t90 or its90_range is set' do
        expect { SPRT.wdev(t90: 0.01)      }.to raise_error(ArgumentError, /its90_range.*(missing|required)/)
        expect { SPRT.wdev(its90_range: 1) }.to raise_error(ArgumentError, /t90.*(missing|required)/)
      end

      it 'raises error when invalid ITS-90 range' do
        expect { SPRT.wdev(t90: 0.01, its90_range: 0)   }.to raise_error(ArgumentError, /unexpected.*range/)
        expect { SPRT.wdev(t90: 0.01, its90_range: 12)  }.to raise_error(ArgumentError), /unexpected.*range/
        expect { SPRT.wdev(t90: 0.01, its90_range: 'a') }.to raise_error(ArgumentError), /unexpected.*range/
      end
    end


  end
end

