require 'test/unit'
require_relative '../src/data_model'

class DataModelTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  class TypeOne < DataModel::DataType
    attribute :id, String
  end
  class TypeTwo < DataModel::DataType
    attribute :id, String
    attribute :mate, TypeOne
  end

  def test_model

    assert(TypeTwo.attributes.keys.one?{|k|k==:id}, 'has id attribute')
    id_t= TypeTwo.attributes[:id]
    assert( id_t[:type] == String)
    mate_t= TypeTwo.attributes[:mate]
    assert( mate_t[:type] == TypeOne)
  end
end