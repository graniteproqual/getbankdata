##
# everything to interact with CDR via soap web services
$: << '.'
require 'pp'
require 'savon'
require 'base64'
require 'json'
require 'settings'
require 'rake'
require 'try_x.rb'
require 'Ob1fix'

###########################
class CDR
  attr_accessor  :pors
  attr_reader    :shared_settings , :soap_settings, :config_file_locations
  include Try_x
  include Rake

  #------------------------------------------------
  def initialize
    @config_file_locations  = Settings.new( './config/config_file_locations.json' ).setting_methods
    @shared_settings        = Settings.new( config_file_locations.shared_settings_json).setting_methods   # folders,
    @soap_settings          = Settings.new( config_file_locations.soap_settings_json).setting_methods     # username password, wsdl name e
  end

  #------------------------------------------------
  def log_some_details( file, what)
    File.open( file, 'w') do |o|
      o.puts what
    end
  end

  #------------------------------------------------
  # Savon client for setting up web service object
  def client
    if @client.nil?
      # problem passing instance variables into the Savon.client code block
      wsdl_file = soap_settings.wsdl_file
      username  = Ob1fix.new.f( soap_settings.wse_username, soap_settings.wse_key)
      password  = soap_settings.wse_password
      # set up connection using wsdl
      @client = Savon.client( soap_version: 2, open_timeout: 20, read_timeout: 20) do
        wsdl wsdl_file
        wsse_auth( username, password )
        convert_request_keys_to :lower_camelcase
        ssl_verify_mode :none
      end
    end
    @client
  end

  #------------------------------------------------
  def por_for_quarter( qtr)
    @pors = {} if @pors.nil?
    if @pors[qtr].nil?
      @pors[ qtr] = {}
      pors_file = shared_settings.por_folder + 'por_' + qtr + '.json'
      if File.exist?( pors_file)
        @pors[ qtr] = JSON.parse( File.read( pors_file))
      else
        @pors[ qtr] = try_x( " retrieve_por_for_quarter( #{qtr})", 3) { retrieve_por_for_quarter( qtr)}
      end
    end
    @pors[ qtr]
  end

  #---------------------------------------------------
  def retrieve_por_for_quarter( qtr)
    retval = nil
    response = client.call(
        :retrieve_panel_of_reporters,
        :message => {:reporting_period_end_date => qtr}
    )

    if response.body[:retrieve_panel_of_reporters_response] and
        response.body[:retrieve_panel_of_reporters_response][:retrieve_panel_of_reporters_result] and
        response.body[:retrieve_panel_of_reporters_response][:retrieve_panel_of_reporters_result][:reporting_financial_institution]
      tmpra = response.body[:retrieve_panel_of_reporters_response][:retrieve_panel_of_reporters_result][:reporting_financial_institution]
      retval = {}
      tmpra.each do |fi|
        retval[fi[ :id_rssd]] = fi
      end

      if retval
        File.open( shared_settings.por_folder + 'por_' + qtr  + '.json', 'w')  do |o|
          o.puts JSON.pretty_generate( retval)
        end
      end
    end
  end

  #----------------------------------------------------------------
  def pors_since_quarter( quarter)
    hash = {}
    quarterlistsince( quarter).each do |qtr|
      hash[qtr] = @pors[ qtr]
    end
    hash
  end

  #----------------------------------------------------------------
  def retrieve_instance_with_idrssd( qtr, idrssd)

    response = try_x( "retrieving facs for idrssd #{idrssd} for qtr #{qtr}",3) do
      client.call(:retrieve_facsimile,
                  :message => {
                      :facsimile_format => 'XBRL',
                      :fi_i_d_type => 'ID_RSSD',
                      :fi_i_d => idrssd,
                      :reporting_period_end_date => qtr})
    end
    decoded_facs = nil
    if response and response.body[:retrieve_facsimile_response] and !response.body[:retrieve_facsimile_response][:retrieve_facsimile_result].nil?
      decoded_facs = Base64.decode64( response.body[:retrieve_facsimile_response][:retrieve_facsimile_result])

      /(\d{4})-(\d\d)-(\d\d)/.match( qtr) ; yr = $1 ; mo = $2 ; dy = $3
      facs_file = shared_settings.inst_doc_folder + 'FFIEC Call FI ' + idrssd + ' (ID_RSSD) ' + mo + dy + yr + '.XBRL.xml'
      log_some_details( facs_file, decoded_facs )
    end
    decoded_facs
  end


  ##
  # this returns a hash of quarters as keys and either single idrssd s or arrays of idsrssd s as values:
  # it kinda looks like this
  # {
  #   "2013-03-31": "175458",
  #   "2012-12-31": [
  #     "1001451",
  #     "175458",
  #     "723158"],
  #   ....
  # original since_date - 2017-09-03T19:09:00
  # }
  def filers_since_date( since_date, quarterlistsince )

    @reporters_since_date= {} if @reporters_since_date.nil?

    quarterlistsince.each do |qtr|
      if @reporters_since_date[ qtr].nil?
        @reporters_since_date[ qtr]={}

        response = client.call(:retrieve_filers_since_date, :message => {:reporting_period_end_date => qtr, :last_update_date_time => since_date})
        if !response.body[:retrieve_filers_since_date_response].nil? and
            !response.body[:retrieve_filers_since_date_response][:retrieve_filers_since_date_result].nil? and
            !response.body[:retrieve_filers_since_date_response][:retrieve_filers_since_date_result][:int].nil?
          @reporters_since_date[ qtr] = response.body[:retrieve_filers_since_date_response][:retrieve_filers_since_date_result][:int]
          log_some_details(  shared_settings.other_doc_folder + '/filers_since_'+ since_date.gsub( ':', '_') + '.json', JSON.pretty_generate( @reporters_since_date))
        end

      end
    end

    @reporters_since_date

  end

end
# quick tests to confirm during development
if __FILE__ == $0

end