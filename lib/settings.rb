$: << '.'
require 'json'
require_relative '../lib/gen_json_methods'

class Settings
  include GenJsonMethods

  def initialize( settings_file)

    @h = JSON.parse( File.read( settings_file))
    @h.transform_values! do |v|
      if v.class.name === 'String'
        if /^~\/.*/.match( v)
          v.gsub!('~/', Dir.home + '/')
        end
        v
      end
    end

  end

  def setting_methods
    @h.extend GenJsonMethods
    @h.gen_json_methods
  end
end

if __FILE__ == $0

end