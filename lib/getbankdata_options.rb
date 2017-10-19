require 'optparse'
require 'ostruct'
require 'pp'

##
# handles parsing of command line options for getbankdata
# the number of options will likely grow over time
class GetBankData_Options

  def self.parse( args)
    options = OpenStruct.new

    # default options
    options.download_type = 'since'
    options.include_qtrs = [12]

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: getbankdata.rb [options]'
      opts.separator ''
      opts.separator 'Specific options:'

      #--------
      opts.on('--include_qtrs m,j,s,d',
              Array,
              'Quarters to include expressed as month numbers,',
              'e.g --include_qtrs 3,6  will include March and June' ) do |include_qtrs|
        options.include_qtrs = include_qtrs.map {|e| e.to_i} if include_qtrs
      end

      #--------
      opts.on('--download_type [DOWNLOAD_TYPE]',
              ["since", "bulk"],
              'Select download_type (since, bulk)') do |d|
        options.download_type = d if d
      end
    end

    opt_parser.parse!(args)
    options
  end
end

######################################
# quick test
if __FILE__ == $0
  options = GetBankData_Options.parse( ARGV)
  pp options
  pp ARGV
end