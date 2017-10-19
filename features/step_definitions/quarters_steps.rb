require 'quarters'

# Given /^a quarter setup with default of no date$/ do
#   @quarters = Quarters.new
# end
# When /^I send it a today message$/ do
#   @message = @quarters.today
# end
# Then /^I should see todays date$/ do
#   expect(@message.strftime('%Y-%m-%d')).to match( DateTime.now.strftime('%Y-%m-%d'))
# end



dt = '2016-03-15'; regexp = Regexp.new("^a quarter setup with a date of #{dt}$")
Given regexp do
  @quarters = Quarters.new
end
When /^I send it a today message to grt back initialization date$/ do
  @message = @quarters.today
end
Then /^I should see initialization date$/ do
  expect(@message.strftime('%Y-%m-%d')).to match( dt)
end
