require 'key_struct'
class Sprt < KeyStruct[rtpw: 25.0, 
                       a: 0.0, b: 0.0, c: 0.0, d: 0.0, 
                       c1: 0.0, c2: 0.0, c3: 0.0, c4: 0.0, c5: 0.0, 
                       w660: 0.0]
  VALID_RANGE = -259.4467..961.88

  def self.wr(t90, unit = :celsius)
    wr_celsius(UnitConversion.new(:temperature).convert(t90, unit, :celsius))
  end

  def self.t90(wr, unit = :celsius)
    UnitConversion.new(:temperature).convert(t90_celsius(wr), :celsius, unit)
  end

  def wdev(t90, its90_range, unit = :celsius)
    raise ArgumentError unless (1..11).include? its90_range
    self.send("wdev#{its90_range}_celsius", UnitConversion.new(:temperature).convert(t90, unit, :celsius))
  end

private
  def self.wr_celsius(t90_celsius)
    raise RangeError unless VALID_RANGE.include? t90_celsius
    if t90_celsius < 0.01
      a = [ -2.13534729, 3.1832472,  -1.80143597,
             0.71727204, 0.50344027, -0.61899395,
            -0.05332322, 0.28021362,  0.10715224,
            -0.29302865, 0.04459872,  0.11868632,
            -0.05248134 ]
      Math.exp(a.each_with_index.map{ |a, i| a*( (Math.log((t90_celsius+273.15)/273.16) + 1.5)/1.5 )**i }.inject(:+))
    else
      c = [  2.78157254,  1.64650916, -0.1371439,
            -0.00649767, -0.00234444,  0.00511868,
             0.00187982, -0.00204472, -0.00046122,
             0.00045724 ]
      c.each_with_index.map{ |c, i| c*((t90_celsius-481)/481)**i }.inject(:+)
    end
  end

  def self.t90_celsius(wr)
    if wr < 1.0
      b = [  0.183324722,  0.240975303,  0.209108771,
             0.190439972,  0.142648498,  0.077993465,
             0.012475611, -0.032267127, -0.075291522,
            -0.05647067,   0.076201285,  0.123893204,
            -0.029201193, -0.091173542,  0.001317696,
            0.026025526 ]
      t90_celsius = b.each_with_index.map{ |b, i| b*(((wr)**(1.0/6)-0.65)/0.35)**i }.inject(:+) * 273.16 - 273.15
    else
      d = [ 439.932854,
            472.41802,
             37.684494,
              7.472018,
              2.920828,
              0.005184,
             -0.963864,
             -0.188732,
              0.191203,
              0.049025 ]
      t90_celsius = d.each_with_index.map{ |d, i| d*((wr-2.64)/1.64)**i }.inject(:+)
    end
    raise RangeError unless VALID_RANGE.include? t90_celsius
    t90_celsius
  end

  def wdev1_celsius(t90_celsius)
    raise RangeError unless (-259.4467..0.01).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a  * ( wr_t90 - 1 ) +
    b  * ( wr_t90 - 1 ) ** 2 +
    c1 * Math.log( wr_t90 ) ** 3 +
    c2 * Math.log( wr_t90 ) ** 4 +
    c3 * Math.log( wr_t90 ) ** 5 +
    c4 * Math.log( wr_t90 ) ** 6 +
    c5 * Math.log( wr_t90 ) ** 7
  end

  def wdev2_celsius(t90_celsius)
    raise RangeError unless (-248.5939..0.01).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a  * ( wr_t90 - 1 ) +
    b  * ( wr_t90 - 1 ) ** 2 +
    c1 * Math.log( wr_t90 ) ** 1 +
    c2 * Math.log( wr_t90 ) ** 2 +
    c3 * Math.log( wr_t90 ) ** 3
  end

  def wdev3_celsius(t90_celsius)
    raise RangeError unless (-218.7916..0.01).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a  * ( wr_t90 - 1 ) +
    b  * ( wr_t90 - 1 ) ** 2 +
    c1 * Math.log( wr_t90 ) ** 2
  end

  def wdev4_celsius(t90_celsius)
    raise RangeError unless (-189.3442..0.01).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a  * ( wr_t90 - 1 ) +
    b  * ( wr_t90 - 1 ) * Math.log(wr_t90)
  end

  def wdev5_celsius(t90_celsius)
    raise RangeError unless (0.0..961.78).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a * ( wr_t90 - 1 ) +
    b * ( wr_t90 - 1 ) ** 2 +
    c * ( wr_t90 - 1 ) ** 3 +
    d * (wr_t90 - w660) ** 2
  end

  def wdev6_celsius(t90_celsius)
    raise RangeError unless (0.0..660.323).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a * ( wr_t90 - 1 ) +
    b * ( wr_t90 - 1 ) ** 2 +
    c * ( wr_t90 - 1 ) ** 3
  end

  def wdev7_celsius(t90_celsius)
    raise RangeError unless (0.0..419.527).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a * ( wr_t90 - 1 ) +
    b * ( wr_t90 - 1 ) ** 2
  end

  def wdev8_celsius(t90_celsius)
    raise RangeError unless (0.0..231.928).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a * ( wr_t90 - 1 ) +
    b * ( wr_t90 - 1 ) ** 2
  end

  def wdev9_celsius(t90_celsius)
    raise RangeError unless (0.0..156.5985).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a * ( wr_t90 - 1 )
  end

  def wdev10_celsius(t90_celsius)
    raise RangeError unless (0.0..29.7646).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a * ( wr_t90 - 1 )
  end

  def wdev11_celsius(t90_celsius)
    raise RangeError unless (-38.8344..29.7646).include? t90_celsius
    wr_t90 = self.class.wr_celsius(t90_celsius)
    a * ( wr_t90 - 1 ) +
    b * ( wr_t90 - 1 ) ** 2
  end
end
