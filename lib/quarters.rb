require 'date'

##
# We have to deal with the concept reporting quarters
# the class contains several methods that make dealing with reporting quarters easier

class Quarters
  attr_accessor :today

  def initialize( now=DateTime.now())
    begin
      if now.class.name === 'DateTime'
        @today = now
      else
        @today = DateTime.now()
      end

    rescue
      puts "Error in initialization, now = #{now.to_s}"
      @today = DateTime.now()
    end
  end

  def todays_year
    today.strftime( '%Y').to_i
  end

  def todays_month
    today.strftime( '%mm').to_i
  end

  def quarter_month( month=todays_month)
    { 1  => 12, 2  => 12, 3  => 12, 4  =>  3,
      5  =>  3, 6  =>  3, 7  =>  6, 8  =>  6,
      9  =>  6, 10 =>  9, 11 =>  9, 12 =>  9 }[ month]
  end

  def quarter_year( year = todays_year)
    (todays_month <= 3) ? year-1 : year
  end

  def last_day_of_month_of( month)
    { 3 => '31', 6 => '30', 9 => '30', 12 => '31'}[month]
  end

  def current_qtr # expressed as last day of preceding reporting quarter
    quarter_year.to_s + lzf( quarter_month) + lzf( last_day_of_month_of(quarter_month))
  end

  def last_2_december_qtrs
    current_yr = today.strftime( '%Y').to_i
    beginning_yr = current_yr - 2
    beginning_qtr = '20' + ('0' + beginning_yr.to_s).slice(-2,2)+'-12-31'
    quarter_list_since( beginning_qtr, [12])
  end

  def lzf( number, total_length=2 )
    str = number.to_s
    str.length >= total_length ? str : (('0'*total_length)+str).slice(0-total_length, total_length)
  end

  def quarter_list_since( from_date, included_months=[3,6,9,12])
    ##
    # returns an array of valid quarter strings from  a particular date
    # ... up to date that was used to initialize this Quarters object (default to DateTime.now)
    # the array is sorted with most recent quarter first
    #
    # == Example:
    #
    #   ra = quarter_list_since( '2011-09-30')  # assume today is Aug 15, 2013
    #
    #   will return: ["2011-09-30","2011-12-31","2012-03-31","2012-06-31"]
    #
    # it will round down to quarter previous to the date passed in.
    # the date parameter must be in the form YYYY-MM-DD,...
    # ...the default used by FDIC All Report instance documents

    return @quarterlistsince[ from_date] if @quarterlistsince && @quarterlistsince[ from_date]

    @quarterlistsince = {} if @quarterlistsince.nil?
    if @quarterlistsince[ from_date].nil?
      @quarterlistsince[ from_date] = []
      from_year = from_date.slice( 0,4).to_i; from_month = from_date.slice( 5,2).to_i

      (from_year..todays_year).each do |y|
        included_months.each do |m|
          if from_year == y
            next if m < from_month
          end
          if y == todays_year
            break if m >= todays_month  # if current month is a "quarter" month, then don't include
          end
          @quarterlistsince[ from_date] << "#{y.to_s}-#{lzf(m)}-#{last_day_of_month_of(m)}"
        end
      end
    end
    return @quarterlistsince[ from_date].sort!.reverse
  end
end
#--------------------------------------------------------------------------------------------------------

# quick tests here, see tests/quarters_test.rb for minitest
if __FILE__ == $0

  qtrs = Quarters.new

  puts 'last 2 december quarters '
  puts qtrs.last_2_december_qtrs


  test_date = '2013-07-09'
  puts 'june quarters list since ' + test_date
  puts qtrs.quarter_list_since( test_date, [6])

  puts "exercising lzf"
  puts "lzf( 1) : #{qtrs.lzf(1)}"
  puts "lzf( 5,5) : #{qtrs.lzf(5,5)}"
  puts "lzf( 533,2) : #{qtrs.lzf(533,2)}"
  puts "current quarter: #{ qtrs.current_qtr}"

  if @log_details
    File.open( st.other_doc_folder + 'quarterlistsince_' + quarter  + '.json', 'w') do |o|
      o.puts JSON.pretty_generate @quarterlistsince[ quarter].sort!.reverse
    end
  end
  puts
  puts "using: 2017, 01, 05"
  qtrs = Quarters.new( DateTime.new(2015, 01, 05))

  test_date = '2013-07-09'
  puts 'june quarters list since ' + test_date
  puts qtrs.quarter_list_since( test_date, [6])

  puts 'last 2 december quarters '+ test_date
  puts qtrs.last_2_december_qtrs

end