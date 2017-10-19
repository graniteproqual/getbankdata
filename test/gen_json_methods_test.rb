# quarters_test / minitest
require 'minitest/autorun'
require 'json'
require_relative '../lib/gen_json_methods'


class GenJsonMethodsTest < Minitest::Test
  include GenJsonMethods
  def test_methods_from_strings
    string_index_json = JSON.parse('{
        "str1": "STRING_ONE",
        "str2": "STRING_TWO"
    }')
    string_index_json.extend GenJsonMethods
    string_index_json.gen_json_methods
    assert_equal string_index_json['str1'], string_index_json.str1
    assert_equal string_index_json['str2'], string_index_json.str2
  end

end

#--------------------------------------------------------------------------------------------------------

# quick tests here, see tests/quarters_test.rb for minitest
