require "date"
# every thing to set and retrieve with since date,
# get since date from file
# write new since date back to file
class SinceDate
  attr_reader :since_date

  def initialize( since_date_file)
    @since_date_file = since_date_file
    open( since_date_file, "r") do |i|
      i.each do |line|
        @since_date = line.strip! if line.length > 2
      end
    end
  end

  def since_date=( since_date)
    @since_date = since_date
    open( @since_date_file, "w") do |o|
      o.puts since_date
    end
  end
end

#################################
if __FILE__ == $0
  # quick tests
  since_date_file = "../since_date.txt"
  sd = SinceDate.new( since_date_file)
  puts "Since Date from file: #{sd.since_date}"
  sd.since_date=(DateTime.now.strftime('%Y-%m-%dT%H:%M:%S'))
  puts "puts updating since datefile to todays date: #{sd.since_date}"
end
