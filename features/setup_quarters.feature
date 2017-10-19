Feature: Setup Quarters
  In order to work with Quarters we need to initialize it first

  Scenario: set up quarter so "today" is set to today's date
    Given a quarter setup with default of no date
    When I send it a today message
    Then I should see todays date

  Scenario: set up quarter so "today" is set to a specific date
    Given a quarter setup with a date of 2016-03-15
    When I send it a today message
    Then I should see 2016-03-15