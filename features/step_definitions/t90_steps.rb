When /^I read (.+) ohms on an SPRT compliant rtd$/ do |res|
  @t90 = Its90.t90(Sprt.new, res.to_f)
end

When /^I read (.+) ohms on an IEC60751 compliant rtd$/ do |res|
  @t90 = Iec60751.t90(Rtd.new, res.to_f)
end

When /^I read (.+) mV on an IEC60584 compliant type (.+) thermocouple$/ do |emf, kind|
  @t90 = Iec60584.t90(Thermocouple.new(kind: kind.to_sym), emf.to_f)
end

Then /^I should get a (.+) degrees Celsius temperature$/ do |t|
  @t90.should be_within(0.0001).of(t.to_f)
end
