require_relative '../../app/services/sprt'

describe SPRT do
  context 'WRef conputation' do
    it 'handles negative temperatures' do
      #SPRT.wref(temperature:  13.8033, unit: :kelvin).should be_within(0.0001).of(-200.0000)
      #SPRT.wref(temperature:  83.8058, unit: :kelvin).should be_within(0.0001).of(-100.0000)
      SPRT.wref(temperature: 273.16  , unit: :kelvin).should be_within(0.0001).of(0.0000)
    end

    xit 'handles positive temperatures' do
      SPRT.wref(temperature:  273.16 , unit: :kelvin).should be_within(0.0001).of(0.0000)
      SPRT.wref(temperature:  933.473, unit: :kelvin).should be_within(0.0001).of(400.0000)
      SPRT.wref(temperature: 1234.93 , unit: :kelvin).should be_within(0.0001).of(850.0000)
    end

    xit 'handls degrees Celsius' do
      SPRT.wref(temperature: 0.01  , unit: :celsius).should be_within(0.0001).of(0.0000)
    end

    xit 'raises error when out of bounds' do
      expect { SPRT.wref(temperature:   13.79, unit: :kelvin) }.to raise_error
      expect { SPRT.wref(temperature: 1235.00, unit: :kelvin) }.to raise_error
    end
  end
end

