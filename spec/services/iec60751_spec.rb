require_relative '../../app/services/iec60751'

describe IEC60751 do
  context 'temperature computation' do
    it 'handles negative temperatures' do
      IEC60751.temperature(resistance:  18.5201).should be_within(0.0001).of(-200.0000)
      IEC60751.temperature(resistance:  60.2558).should be_within(0.0001).of(-100.0000)
      IEC60751.temperature(resistance: 100.0000).should be_within(0.0001).of(0.0000)
    end

    it 'handles positive temperatures' do
      IEC60751.temperature(resistance: 100.0000).should be_within(0.0001).of(0.0000)
      IEC60751.temperature(resistance: 247.0920).should be_within(0.0001).of(400.0000)
      IEC60751.temperature(resistance: 390.4811).should be_within(0.0001).of(850.0000)
    end

    it 'raises error when out of bounds' do
      expect { IEC60751.temperature(resistance:  18.50) }.to raise_error
      expect { IEC60751.temperature(resistance: 390.50) }.to raise_error
    end
  end

  context 'resistance computation' do
    it 'handles resistance at or below R0' do
      IEC60751.resistance(temperature: -200.00).should be_within(0.0001).of(18.5201)
      IEC60751.resistance(temperature: -100.00).should be_within(0.0001).of(60.2558)
      IEC60751.resistance(temperature: 0.00).should    be_within(0.0001).of(100.0000)
    end

    it 'handles resistance at or above R0' do
      IEC60751.resistance(temperature: 0.00).should   be_within(0.0001).of(100.0000)
      IEC60751.resistance(temperature: 400.00).should be_within(0.0001).of(247.0920)
      IEC60751.resistance(temperature: 850.00).should be_within(0.0001).of(390.4811)
    end

    it 'raises error when out of bounds' do
      expect { IEC60751.resistance(temperature: -201.00) }.to raise_error
      expect { IEC60751.resistance(temperature:  851.00) }.to raise_error
    end

    it 'raises error when no temperature is set' do
      expect { IEC60751.resistance }.to raise_error
    end
  end
end
