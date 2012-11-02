class RTD
  def self.temperature(params)
    type = params.delete(:type) { |el| raise "#{el} is required!" }
    case type
    when :iec60751 then IEC60751.temperature(params)
    else raise "type '#{type}' not expected"
    end
    
  end
end
