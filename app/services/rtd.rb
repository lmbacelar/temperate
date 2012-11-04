class RTD
  def self.temperature(params)
    type = params.delete(:type) { |t| raise ArgumentError.new("#{t} is required") }
    case type
    when :iec60751 then IEC60751.temperature(params)
    when :sprt     then SPRT.temperature(params)
    else raise ArgumentError.new('unexpected type')
    end
  end
end
