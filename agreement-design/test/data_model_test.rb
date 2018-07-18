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

  DataModel::domain :TestModel do

    datatype :TypeOne do
      attribute :id, String
    end

    datatype :TypeTwo do
      attribute :id, String
      attribute :mate, DataModel::TestModel::TypeOne
    end

  end

  def test_model
    assert(DataModel::TestModel::TypeTwo.attributes.keys.one? {|k| k == :id}, 'has id attribute')
    id_t = DataModel::TestModel::TypeTwo.attributes[:id]
    assert(id_t[:type] == String)
    mate_t = DataModel::TestModel::TypeTwo.attributes[:mate]
    assert(mate_t[:type] == DataModel::TestModel::TypeOne)
    pp DataModel::Records.types
    pp DataModel::Records::Catalogue.attributes

  end

end