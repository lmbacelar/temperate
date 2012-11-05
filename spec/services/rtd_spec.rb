require_relative '../../app/services/rtd'
require_relative '../../app/services/iec60751_rtd'
require_relative '../../app/services/sprt'
require_relative '../../app/services/unit_conversion'

#
# TODO: isolate from iec60751_rtd, sprt, unit_conversion classes
#
describe Rtd do
  it 'creates rtd with correct parameters' do
    t = Rtd.temperature(type: :iec60751, r0: 101.0,  r: 100.0).should_not == 0.0
    Rtd.temperature(type: :iec60751, a:  3.8083e-03, r: 100.0).should_not == t
    Rtd.temperature(type: :iec60751, b:  -5.875e-07, r: 100.0).should_not == t
    Rtd.temperature(type: :iec60751, c:  -4.283e-12, r: 100.0).should_not == t
    Rtd.temperature(type: :iec60751, r0: 100.0,      r: 100.0).should     == 0.0
  end

  it 'handles IEC60751' do
    Rtd.temperature(type: :iec60751, r: 100.0).should == 0.0
  end

  xit 'handles SPRT' do
    Rtd.temperature(type: :sprt, r: 25.0).should == 0.0
  end

  it 'raises error when no type is set' do
    expect { Rtd.temperature(resistance: 100.0) }.to raise_error(ArgumentError)
  end

  it 'raises error when unknown type is set' do
    expect { Rtd.temperature(type: :dummy, resistance: 100.0) }.to raise_error(ArgumentError)
  end
end
