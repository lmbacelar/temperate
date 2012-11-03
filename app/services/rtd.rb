class RTD
  def self.temperature(params)
    type = params.delete(:type) { |t| raise "#{t} is required!" }
    case type
    when :iec60751 then IEC60751.temperature(params)
    when :sprt     then SPRT.temperature(params)
    else raise "type '#{type}' not expected"
    end
  end
end
