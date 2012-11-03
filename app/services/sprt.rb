class SPRT

  def self.wref(params)
    parse params
    raise 'temperature is required!' unless @@temperature
    raise 'out of bounds!' if !@@skip_check && (@@temperature < -200.00 || @@temperature > 850.00)

  end

private
  def self.parse(params)
    @@temperature = params[:temperature]
    @@unit = params[:unit] || :celsius
    ###@@max_error   = params[:max_error]   ||  0.0001
    ###@@skip_check  = params[:skip_check]  ||  false
    ###@@r0          = params[:R0]          ||  100.0
    ###@@a           = params[:A]           ||  3.9083e-03
    ###@@b           = params[:B]           || -5.7750e-07
    ###@@c           = params[:C]           || -4.1830e-12
  end
end
