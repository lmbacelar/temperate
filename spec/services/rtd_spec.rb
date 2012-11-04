require_relative '../../app/services/rtd'
require_relative '../../app/services/iec60751'
require_relative '../../app/services/sprt'

describe RTD do
  it 'handles IEC 60751' do
    IEC60751.should_receive(:temperature).with(resistance: 100.0)
    RTD.temperature(type: :iec60751, resistance: 100.0)
  end

  it 'handles SPRT' do
    SPRT.should_receive(:temperature).with(resistance: 25.0)
    RTD.temperature(type: :sprt, resistance: 25.0)
  end

  it 'raises exception when no type is set' do
    expect { RTD.temperature(resistance: 100.0) }.to raise_error(ArgumentError, /type.*required/)
  end

  it 'raises exception when unknown type is set' do
    expect { RTD.temperature(type: :dummy, resistance: 100.0) }.to raise_error(ArgumentError, /unexpected.*type/)
  end
end
