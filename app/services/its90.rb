# ALL TEMPERATURES IN CELSIUS
#
class Its90
  VALID_T90_RANGE = -259.4467..961.88
  VALID_WR_RANGE  =  0.00119007..4.28642053

  A = [ -2.13534729, 3.1832472,  -1.80143597,
         0.71727204, 0.50344027, -0.61899395,
        -0.05332322, 0.28021362,  0.10715224,
        -0.29302865, 0.04459872,  0.11868632,
        -0.05248134 ]
  
  B = [  0.183324722,  0.240975303,  0.209108771,
         0.190439972,  0.142648498,  0.077993465,
         0.012475611, -0.032267127, -0.075291522,
        -0.05647067,   0.076201285,  0.123893204,
        -0.029201193, -0.091173542,  0.001317696,
         0.026025526 ]

  C = [  2.78157254,  1.64650916, -0.1371439,
        -0.00649767, -0.00234444,  0.00511868,
         0.00187982, -0.00204472, -0.00046122,
         0.00045724 ]

  D = [ 439.932854, 472.41802, 37.684494,
          7.472018,   2.920828, 0.005184,
         -0.963864,  -0.188732, 0.191203,
          0.049025 ]

  WDEV_EQUATIONS = [ { valid: (-259.4467..0.01),   k: %w(c1 c2 c3 c4 c5), n: 2 }, 
                     { valid: (-248.5939..0.01),   k: %w(c1 c2 c3      ), n: 0 },
                     { valid: (-218.7916..0.01),   k: %w(c1            ), n: 1 },
                     { valid: (-189.3442..0.01),   k: %w(              )       },
                     { valid: (0.0..961.78),       k: %w(a  b  c  d    )       }, 
                     { valid: (0.0..660.323),      k: %w(a  b  c       )       }, 
                     { valid: (0.0..419.527),      k: %w(a  b          )       }, 
                     { valid: (0.0..231.928),      k: %w(a  b          )       }, 
                     { valid: (0.0..156.5985),     k: %w(a             )       }, 
                     { valid: (0.0..29.7646),      k: %w(a             )       }, 
                     { valid: (-38.8344..29.7646), k: %w(a  b          )       } ] 

  def self.wr(t90)
    raise RangeError unless VALID_T90_RANGE.include? t90
    if t90< 0.01
      Math.exp(A.each_with_index.map{ |a, i| a*( (Math.log((t90+273.15)/273.16) + 1.5)/1.5 )**i }.inject(:+))
    else
      C.each_with_index.map{ |c, i| c*((t90-481)/481)**i }.inject(:+)
    end
  end

  def self.t90r(wr)
    raise RangeError unless VALID_WR_RANGE.include? wr
    if wr < 1.0
      B.each_with_index.map{ |b, i| b*(((wr)**(1.0/6)-0.65)/0.35)**i }.inject(:+) * 273.16 - 273.15
    else
      D.each_with_index.map{ |d, i| d*((wr-2.64)/1.64)**i }.inject(:+)
    end
  end

  def self.wdev(sprt, t90)
    equation = WDEV_EQUATIONS[sprt.range - 1]
    raise RangeError unless equation[:valid].include? t90

    wr_t90 = wr(t90)
    case sprt.range
    when 1..4
      wdev  = sprt.a * (wr_t90 - 1)
      wdev += sprt.range == 4 ? sprt.b * (wr_t90 - 1) * Math.log(wr_t90) : sprt.b * (wr_t90 - 1)**2
      wdev += equation[:k].each_with_index.map{ |k, i| eval("sprt.#{k}") * Math.log(wr_t90)**(i + equation[:n]) }.inject(:+) || 0
    when 5..11
      wdev   = sprt.d * (wr_t90 - sprt.w660)**2 if equation[:k].delete('d')
      wdev ||= 0
      wdev  += equation[:k].each_with_index.map{ |k, i| eval("sprt.#{k}") * (wr_t90 - 1)**(i+1) }.inject(:+)
    end
  end

  def self.t90(sprt, r)
    w = r / sprt.rtpw
    t = t90r(w)
    t90r(w - wdev(sprt, t))
  end
end
