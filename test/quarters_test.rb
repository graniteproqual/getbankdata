# quarters_test / minitest
require 'minitest/autorun'
require_relative '../lib/quarters'


class QuartersTest < Minitest::Test

  def test_default_init_with_no_date_returns_today_eq_todays_date
    qtrs = Quarters.new
    assert_equal qtrs.today.strftime('%Y-%m-%d'), DateTime.now.strftime('%Y-%m-%d')
  end

  def test_default_init_with_no_date_returns_DateTime
    qtrs = Quarters.new
    assert_kind_of DateTime, qtrs.today
  end

  def test_init_with_particular_date_returns_today_eq_particular_date
    dt = DateTime.new( 2015, 6, 15)
    qtrs = Quarters.new( dt)
    assert_equal qtrs.today, DateTime.new( 2015, 6, 15)
  end

  def test_init_with_bad_date_returns_todays_date
    qtrs = Quarters.new( 'bad')
    assert_equal qtrs.today.strftime('%Y-%m-%d'), DateTime.now.strftime('%Y-%m-%d')
  end

  def test_last_2_december_quarters_returns_appropriate_quarters
    dt = DateTime.new( 2015, 6, 15)
    qtrs = Quarters.new( dt)
    assert_includes qtrs.last_2_december_qtrs, '2014-12-31'
    assert_includes qtrs.last_2_december_qtrs, '2013-12-31'
    assert_equal qtrs.last_2_december_qtrs.length, 2
  end


  def test_quarter_list_since_using_returns_appropriate_quarters
    dt = DateTime.new( 2015, 6, 15)
    from_date = '2005-03-31' # 41 quarters
    qtrs_list = Quarters.new( dt).quarter_list_since(from_date)
    assert_includes qtrs_list,'2005-03-31'
    assert_includes qtrs_list,'2015-03-31'
    refute_includes qtrs_list,'2004-12-31'
    refute_includes qtrs_list,'2015-06-30'
    assert_equal qtrs_list.length,41, "qtrs_list length should 41 but it equals #{qtrs_list.length}"
  end

end
