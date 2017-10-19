# quarters_test / minitest
require 'minitest/autorun'
require_relative '../lib/since_date'


class SinceDateTest < Minitest::Test

  def setup
    @since_date_test_file = './since_date_test_file.txt'
    @first_date = '2015-03-31'
    @later_date = '2017-06-30'
    open(@since_date_test_file, 'w+') { |f| f.puts @first_date}
  end

  def test_reading_first_date_from_file
    sd = SinceDate.new( @since_date_test_file)
    assert_equal @first_date, sd.since_date
  end

  def test_updating_since_date_with_later_date
    sd = SinceDate.new( @since_date_test_file)
    sd.since_date=@later_date
    assert_equal @later_date, sd.since_date

    since_date = ''
    open( @since_date_test_file, "r") do |i|
      i.each do |line|
        since_date = line.strip! if line.length > 2 # last "filled in" line
      end
    end
    assert_equal @later_date, since_date
  end


end
