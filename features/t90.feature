Feature: Users can get temperature from probe's electrical output

  Scenario: User has an IEC60751 compliant rtd
    When I read 100.0 ohms on an IEC60751 compliant rtd
    Then I should get a 0.0 degrees Celsius temperature

  Scenario: User has an SPRT compliant rtd
    When I read 25.0 ohms on an SPRT compliant rtd
    Then I should get a 0.01 degrees Celsius temperature

  Scenario: User has an IEC60584 compliant type k thermocouple
    When I read 0.0 mV on an IEC60584 compliant type k thermocouple
    Then I should get a 0.0 degrees Celsius temperature
