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

    datatype :BasicType do
      attribute :id, String
    end

    datatype :ReferencingType do
      attribute :id, String
      attribute :mate, DataModel::TestModel::BasicType
    end

    datatype :DerivedType, :ReferencingType do
      attribute :more, String
    end

    datatype :DerivedTypeNamingClass, DataModel::TestModel::ReferencingType do
      attribute :othermore, String
    end

  end

  def test_model
    assert(contains(DataModel::TestModel::BasicType, :id), 'has id attribute')
    id_t = DataModel::TestModel::BasicType.attributes[:id]
    assert(id_t[:type] == String)

    mate_t = DataModel::TestModel::ReferencingType.attributes[:mate]
    assert(mate_t[:type] == DataModel::TestModel::BasicType)

    assert(contains( DataModel::TestModel::DerivedType, :more), "has derived attribute")
    assert(contains( DataModel::TestModel::DerivedType, :mate), "has derived attribute")
    assert(contains( DataModel::TestModel::DerivedType, :id), "has derived attribute")
    assert(contains( DataModel::TestModel::DerivedTypeNamingClass, :othermore), "has derived attribute")
    assert(contains( DataModel::TestModel::DerivedTypeNamingClass, :id), "has derived attribute")
  end

  private

  def contains(type, attr)
    type.attributes.keys.one? {|k| k == attr }
  end

end