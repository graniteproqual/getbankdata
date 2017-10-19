##
# collect call report data from FDIC Central Data Repository (CDR)
# in the form of instance documents and write to a shared folder to be retrieved later for processing

$: << './lib'

require 'getbankdata_options'
require 'quarters'
require 'settings'
require 'since_date'
require 'cdr'

############################################
if __FILE__ == $0
  options = GetBankData_Options.parse( ARGV)
  config_file_locations = Settings.new( './config/config_file_locations.json' ).setting_methods
  cdr   = CDR.new
  qtrs  = Quarters.new
  other_settings = Settings.new(config_file_locations.other_settings_json ).setting_methods  # setting_methods is so we use shortcut methods to refer to settings elements
                                        # e.g. st.beg_qtr instead of st[ 'beg_qtr']

  date_format = '%Y-%m-%dT%H:%M:%S'

  case options.download_type
    when 'since'  # retrieve december quarters call reports submitted since last "since_date"
      sd = SinceDate.new( "./since_date.txt")
      new_since_date = DateTime.now.strftime( date_format )
      cdr.filers_since_date( sd.since_date, qtrs.last_2_december_qtrs ).each do |qtr, idrssds|
        if /Array/.match( idrssds.class.to_s)
          if !idrssds.empty?
            idrssds.each do |idrssd|
              cdr.retrieve_instance_with_idrssd( qtr, idrssd)
            end
          end
        else
          if !idrssds.empty?
            cdr.retrieve_instance_with_idrssd( qtr, idrssds.to_s )
          end
        end

      end
      sd.since_date = new_since_date
    when 'bulk' # retrieve all december quarters call reports since "beg_qtr" in the shared_settings.json file
      earliest_date = st.beg_qtr
      qtrs.quarter_list_sincequarter( other_settings.beg_qtr, [12] ).each do | qtr|
        cdr.por_for_quarter( qtr).each do | por|
          por.each do |idrssd|
            cdr.retrieve_instance_with_idrssd( qtr, idrssd)
          end
        end
      end
  end

end


