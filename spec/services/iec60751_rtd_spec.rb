require_relative '../../app/services/iec60751_rtd'
require_relative '../../app/services/unit_conversion'

describe Iec60751Rtd do
  context 'temperature computation' do
    it 'handles negative temperatures' do
      subject.temperature( 18.5201).should be_within(0.0001).of(-200.0000)
      subject.temperature( 60.2558).should be_within(0.0001).of(-100.0000)
      subject.temperature(100.0000).should be_within(0.0001).of(   0.0000)
    end

    it 'handles positive temperatures' do
      subject.temperature(100.0000).should be_within(0.0001).of(  0.0000)
      subject.temperature(247.0920).should be_within(0.0001).of(400.0000)
      subject.temperature(390.4811).should be_within(0.0001).of(850.0000)
    end

    it 'handles kelvin units' do
      subject.temperature( 18.5201, :kelvin).should be_within(0.0001).of(  73.1500)
      subject.temperature(100.0000, :kelvin).should be_within(0.0001).of( 273.1500)
      subject.temperature(390.4811, :kelvin).should be_within(0.0001).of(1123.1500)
    end

    it 'raises error when out of range' do
      expect { subject.temperature( 18.00) }.to raise_error(RangeError)
      expect { subject.temperature(391.00) }.to raise_error(RangeError)
    end
  end

  context 'resistance computation' do
    it 'handles resistance at or below R0' do
      subject.resistance(-200.00).should be_within(0.0001).of( 18.5201)
      subject.resistance(-100.00).should be_within(0.0001).of( 60.2558)
      subject.resistance(   0.00).should be_within(0.0001).of(100.0000)
    end

    it 'handles resistance at or above R0' do
      subject.resistance(  0.00).should be_within(0.0001).of(100.0000)
      subject.resistance(400.00).should be_within(0.0001).of(247.0920)
      subject.resistance(850.00).should be_within(0.0001).of(390.4811)
    end

    it 'handles kelvin units' do
      subject.resistance(  73.15, :kelvin).should be_within(0.0001).of( 18.5201)
      subject.resistance( 273.15, :kelvin).should be_within(0.0001).of(100.0000)
      subject.resistance(1123.15, :kelvin).should be_within(0.0001).of(390.4811)
    end

    it 'raises error when out of range' do
      expect { subject.resistance(-201.00) }.to raise_error(RangeError)
      expect { subject.resistance( 851.00) }.to raise_error(RangeError)
    end
  end
end
