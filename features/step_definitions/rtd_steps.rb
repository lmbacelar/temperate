When /^I read (.+) ohms on a rtd of type SPRT$/ do |r|
  @temperature = Its90.t90(Sprt.new, r.to_f)
end

When /^I read (.+) ohms on a rtd of type IEC60751$/ do |r|
  @temperature = Iec60751.temperature(Rtd.new, r.to_f)
end

Then /^I should get a (.+) degrees Celsius temperature$/ do |t|
  @temperature.should be_within(0.0001).of(t.to_f)
end
