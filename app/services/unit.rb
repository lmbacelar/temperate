class Unit
  def self.convert(params)
    t     = params.fetch(:t)
    from  = params.fetch(:from).downcase.to_sym
    to    = params.fetch(:to).downcase.to_sym
    delta = params[:delta] || false

    if from != :celsius
      factor = to_celsius(from)
      t = t * factor[0] + (delta ? 0 : factor[1])
    end
    raise 'out of bounds' if t < -273.1501
    if to != :celsius
      factor = to_celsius(to)
      t = (t - (delta ? 0 : factor[1])) / factor[0]
    end
    t
  end

private
  def self.to_celsius(from)
    # returns array of gain, offset
    case from.downcase.to_sym
    when :celsius    then [1    ,  0]
    when :kelvin     then [1    , -273.15]
    when :fahrenheit then [1/1.8, -32/1.8]
    when :rankine    then [1/1.8, -273.15]
    else raise 'unexpected unit!'
    end
  end
end