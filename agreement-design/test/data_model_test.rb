require 'test/unit'
require_relative '../src/data_model'
include DataModel

class DataModelTest < Test::Unit::TestCase

  DataModel::domain :TestModel do

    datatype :BasicType do
      attribute :id, String
    end
    datatype :Table do
      MULT = [0..10]
      DESC = "table of values"
      attribute :vals, Integer,
                :multiplicity => MULT,
                :description => DESC
      attribute :morevals, String, 2..5, "array of strings"
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
    assert_equal(1..1, DataModel::TestModel::BasicType.attributes[:id][:multiplicity], "has default multiplicity")
    assert(id_t[:type] == String)

    assert_equal(MULT, DataModel::TestModel::Table.attributes[:vals][:multiplicity]);
    assert_equal(2..5, DataModel::TestModel::Table.attributes[:morevals][:multiplicity]);

    assert_equal(MULT, DataModel::TestModel::Table.attributes[:vals][:multiplicity], "has multiplicity")
    assert_equal(DESC, DataModel::TestModel::Table.attributes[:vals][:description], "has description")

    mate_t = DataModel::TestModel::ReferencingType.attributes[:mate]
    assert(mate_t[:type] == DataModel::TestModel::BasicType)

    assert(contains(DataModel::TestModel::DerivedType, :more), "has derived attribute")
    assert(contains(DataModel::TestModel::DerivedType, :mate), "has derived attribute")
    assert(contains(DataModel::TestModel::DerivedType, :id), "has derived attribute")
    assert(contains(DataModel::TestModel::DerivedTypeNamingClass, :othermore), "has derived attribute")
    assert(contains(DataModel::TestModel::DerivedTypeNamingClass, :id), "has derived attribute")
  end

  private

  def contains(type, attr)
    type.attributes.keys.one? {|k| k == attr}
  end

end