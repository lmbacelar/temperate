require_relative '../../app/services/sprt'
require_relative '../../app/services/unit_conversion'

describe Sprt do
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
          Sprt.wr(ex[:t90]).should be_within(0.0000001).of(ex[:wr])
        end
      end

      it 'handles kelvin units' do
        Sprt.wr(273.16, :kelvin).should be_within(0.0000001).of(1.00000000)
      end

      it 'raises error when out of range' do
        expect { Sprt.wr(-259.50) }.to raise_error(RangeError)
        expect { Sprt.wr( 961.90) }.to raise_error(RangeError)
      end
    end

    context 't90 computation' do
      examples.each do |ex|
        it "handles #{ex[:point]} fixed point" do
          Sprt.t90(ex[:wr]).should be_within(0.00013).of(ex[:t90])
        end
      end

      it 'handles kelvin units' do
        Sprt.t90(1.00000000, :kelvin).should be_within(0.00013).of(273.16)
      end

      it 'raises error when out of range' do
        expect { Sprt.t90(0.001) }.to raise_error(RangeError)
        expect { Sprt.t90(4.290) }.to raise_error(RangeError)
      end
    end
  end

  context 'deviation functions' do
    context 'wdev computation' do
      it 'computes no deviation when all zero constants' do
        Sprt.new.wdev(0.0, 1).should == 0.0
      end

      it 'raises error when invalid ITS-90 range' do
        expect { Sprt.new.wdev(0.01, 0)   }.to raise_error(ArgumentError)
        expect { Sprt.new.wdev(0.01, 12)  }.to raise_error(ArgumentError)
        expect { Sprt.new.wdev(0.01, 'a') }.to raise_error(ArgumentError)
      end
    end


  end
end

