class SPRT

  MAX_ITERATIONS = 50
  LLIMIT = -259.4467
  ULIMIT = 961.88
                  
  def self.wr(params)
    parse params
    raise ArgumentError.new('t90 is required!') unless @@t90
    wr_celsius
  end

  def self.t90(params)
    parse params
    raise ArgumentError.new('wr is required!') unless @@wr
    Unit.convert(t: t90_celsius, from: :celsius, to: @@unit)
  end

  def self.wdev(params)
    parse params
    raise ArgumentError.new('t90 is required!')         unless @@t90
    raise ArgumentError.new('its90_range is required!') unless @@its90_range

    case @@its90_range
    when  1 then wdev1
    when  2 then wdev2
    when  3 then wdev3
    when  4 then wdev4
    when  5 then wdev5
    when  6 then wdev6
    when  7 then wdev7
    when  8 then wdev8
    when  9 then wdev9
    when 10 then wdev10
    when 11 then wdev11
    else raise ArgumentError.new('unexpected its90 range!')
    end
  end

private
  def self.parse(params={})
    @@r           = params[:r]
    @@rtpw        = params[:rtpw]
    @@t90         = params[:t90]
    @@wr          = params[:wr]
    @@unit        = params[:unit] ||  :celsius
    @@its90_range = params[:its90_range]

    @@t90c        = Unit.convert(t: @@t90, from: @@unit, to: :celsius) if @@t90
  end

  def self.wr_celsius
    raise RangeError.new('t90 is out of range!') if @@t90c < LLIMIT || @@t90c > ULIMIT
    if @@t90c < 0.01
      a = [ -2.13534729, 3.1832472,  -1.80143597,
             0.71727204, 0.50344027, -0.61899395,
            -0.05332322, 0.28021362,  0.10715224,
            -0.29302865, 0.04459872,  0.11868632,
            -0.05248134 ]
      Math.exp(a.each_with_index.map{ |a, i| a*( (Math.log((@@t90c+273.15)/273.16) + 1.5)/1.5 )**i }.inject(:+))
    else
      c = [  2.78157254,  1.64650916, -0.1371439,
            -0.00649767, -0.00234444,  0.00511868,
             0.00187982, -0.00204472, -0.00046122,
             0.00045724 ]
      c.each_with_index.map{ |c, i| c*((@@t90c-481)/481)**i }.inject(:+)
    end
  end

  def self.t90_celsius
    if @@wr < 1.0
      b = [  0.183324722,  0.240975303,  0.209108771,
             0.190439972,  0.142648498,  0.077993465,
             0.012475611, -0.032267127, -0.075291522,
            -0.05647067,   0.076201285,  0.123893204,
            -0.029201193, -0.091173542,  0.001317696,
             0.026025526 ]
      t = b.each_with_index.map{ |b, i| b*(((@@wr)**(1.0/6)-0.65)/0.35)**i }.inject(:+) * 273.16 - 273.15
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
      t = d.each_with_index.map{ |d, i| d*((@@wr-2.64)/1.64)**i }.inject(:+)
    end
    raise RangeError.new('t90 is out of range!') if t < LLIMIT || t > ULIMIT
    t
  end
end
