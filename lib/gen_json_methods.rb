require 'json'

##
# generates methods for all string indices in a json string
# this is for convenience and access of the values in a similar way to what can be accomplished with javascript
# to use:
# given a json string,              e.g. json = '{"aaa" :"AAA", "bbb" :"BBB"}'
# parse to get a hash,              e.g. hash = JSON.parse( json)
# extend the hash with this module. e.g. hash.extend GenJsonMethods
# and run gen_json_methods          e.g. hash.gen_json_methods
# then: hash.aaa == 'AAA'    hash.bbb == 'BBB'

module GenJsonMethods
  def gen_json_methods
    self.each do |name, retval|
      method_name = nil
      case name.class.name
        when 'String'
          method_name = name
      end
      if method_name
        self.class.send( :define_method,method_name) do |*args, &block|
          self[name]
        end
      end
    end
  end

end

if __FILE__ == $0

  jctest = JSON.parse( '{"aaa" :"AAA", "bbb" :"BBB"}')

  jctest.extend GenJsonMethods
  jctest.gen_json_methods

  puts jctest

  puts "jctest.aaa : #{jctest.aaa}"
  puts "jctest.bbb : #{jctest.bbb}"

end