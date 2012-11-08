Feature: Users can get temperature from resistance

  Scenario: User has an rtd of type IEC60751
    When I read 100.0 ohms on a rtd of type IEC60751
    Then I should get a 0.0 degrees Celsius temperature

  Scenario: User has an rtd of type SPRT
    When I read 25.0 ohms on a rtd of type SPRT
    Then I should get a 0.01 degrees Celsius temperature
