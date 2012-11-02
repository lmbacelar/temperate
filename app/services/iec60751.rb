class IEC60751

  MAX_ITERATIONS = 50
                  
  def self.resistance(params)
    parse params
    raise 'temperature is required!' unless @@temperature
    raise 'out of bounds!' if !@@skip_check && (@@temperature < -200.00 || @@temperature > 850.00)

    if @@temperature < 0.00
      @@r0*(1 + @@a*@@temperature + @@b*@@temperature**2 + @@c*(@@temperature - 100)*@@temperature**3)
    elsif @@temperature <= 850.00
      @@r0*(1 + @@a*@@temperature + @@b*@@temperature**2)
    end
  end

  def self.temperature(params)
    parse params
    raise 'resistance is required!' unless @@resistance

    return 0.00 if @@resistance == @@r0

    t = approximate_temperature(params)
    MAX_ITERATIONS.times do
      s = (@@resistance - @@r0) / t
      r = resistance(params.merge(temperature: t, skip_check: true))
      if (r - @@resistance).abs < s * @@max_error
        raise 'out of bounds!' if (t < -200.00 || t > 850.00)
        return t
      end
      t = t - (r - @@resistance) / s
    end
    raise 'iteration on reverse function did not converge!'
  end

private
  def self.parse(params)
    @@resistance  = params[:resistance]
    @@temperature = params[:temperature]
    @@max_error   = params[:max_error]   ||  0.0001
    @@skip_check  = params[:skip_check]  ||  false
    @@r0          = params[:R0]          ||  100.0
    @@a           = params[:A]           ||  3.9083e-03
    @@b           = params[:B]           || -5.7750e-07
    @@c           = params[:C]           || -4.1830e-12
  end

  def self.approximate_temperature(params)
    if @@resistance >= @@r0
      (-@@a + Math.sqrt(@@a**2 - 4 * @@b * (1 - @@resistance / @@r0))) / (2 * @@b)
    else
      ((@@resistance / @@r0) - 1) / (@@a + 100 * @@b)
    end
  end

end

