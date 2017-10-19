#########################################################################
###   log.rb ############################################################
#########################################################################
module Log
  require 'rubygems'
  require 'log4r'
  require 'log4r/configurator'
  include Log4r
  def get_log( log_file_name, logger_trunc, logger_level)
    #     Configurator.custom_levels( 
    #     :debug,
    #     :info,
    #     :warning,
    #     :severe)
    if !Logger[ log_file_name]
      log = Logger.new(  log_file_name, nil, 'true' )
      pf = PatternFormatter.new( :pattern => '%l  %d: %m')
      fo   = FileOutputter.new( log_file_name, :filename => log_file_name,:trunc => logger_trunc, :formatter => pf) #, :formatter => p)
      log.outputters = fo
      log.level = 1
      else
      log = Logger[ log_file_name]
    end
  return log
  end
  
  # --------------------
  def logstart
    logger.info( "")
    logger.info( "")
    logger.info( " : ---- .rb starting at #{DateTime.now.to_s} ----\n" +
    "                | products_hash : #{@st.products_hash}\n" +
    "                | trac_pjts_loc : #{@st.trac_pjts_loc}\n" +
    "                | db_adapter    : #{@st.db_adapter   }\n" +
    "                | db_host       : #{@st.db_host      }\n" )
  end 

  # --------------------
  def logexception( msg, err, trace)
    puts "in logexception"
    logtext = "\n\n" + 
    "           #{msg}\n" +
    "           #{err}\n"
    
    
    trace.each do |line|
      logtext << "           " + line + "\n"
      puts line
    end
    logger.info logtext
  end      
  
  
end  