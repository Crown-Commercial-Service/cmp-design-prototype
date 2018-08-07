require 'test/unit'
require_relative '../src/data_model'
include DataModel

DataModel::domain :TestMetamodel do

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
    attribute :mate, TestMetamodel::BasicType
  end

  datatype :DerivedType, :ReferencingType do
    attribute :more, String
  end

  datatype :DerivedTypeNamingClass, TestMetamodel::ReferencingType do
    attribute :othermore, String
  end

  datatype :Empty do

  end

end

class DataModelTest < Test::Unit::TestCase


  def test_metamodel
    assert(contains(TestMetamodel::BasicType, :id), 'has id attribute')
    id_t = TestMetamodel::BasicType.attributes[:id]
    assert_equal(1..1, TestMetamodel::BasicType.attributes[:id][:multiplicity], "has default multiplicity")
    assert(id_t[:type] == String)

    assert_equal(MULT, TestMetamodel::Table.attributes[:vals][:multiplicity]);
    assert_equal(2..5, TestMetamodel::Table.attributes[:morevals][:multiplicity]);

    assert_equal(MULT, TestMetamodel::Table.attributes[:vals][:multiplicity], "has multiplicity")
    assert_equal(DESC, TestMetamodel::Table.attributes[:vals][:description], "has description")

    mate_t = TestMetamodel::ReferencingType.attributes[:mate]
    assert(mate_t[:type] == TestMetamodel::BasicType)

    assert(contains(TestMetamodel::DerivedType, :more), "has derived attribute")
    assert(contains(TestMetamodel::DerivedType, :mate), "has derived attribute")
    assert(contains(TestMetamodel::DerivedType, :id), "has derived attribute")
    assert(contains(TestMetamodel::DerivedTypeNamingClass, :othermore), "has derived attribute")
    assert(contains(TestMetamodel::DerivedTypeNamingClass, :id), "has derived attribute")
  end

  TestMetamodel.new :Test_Model do
    table do
      vals 1
      vals 2
    end
  end

  def test_model
    assert( TestMetamodel::Test_Model.contents[:table][0].attributes[:vals][0] == 1, "has vals" )
  end

  private

  def contains(type, attr)
    type.attributes.keys.one? {|k| k == attr}
  end

end