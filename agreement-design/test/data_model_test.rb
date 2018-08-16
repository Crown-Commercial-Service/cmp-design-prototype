require 'test/unit'
require_relative '../src/data_model'
include DataModel
require 'test_model'

class DataModelTest < Test::Unit::TestCase
  
  def test_metamodel
    assert(contains(TestModel::BasicType, :id), 'has id attribute')
    id_t = TestModel::BasicType.attributes[:id]
    assert_equal(1..1, TestModel::BasicType.attributes[:id][:multiplicity], "has default multiplicity")
    assert(id_t[:type] == String)

    assert_equal(MULT, TestModel::Table.attributes[:vals][:multiplicity]);
    assert_equal(2..5, TestModel::Table.attributes[:morevals][:multiplicity]);
    assert_equal("Test type", TestModel::Table.description);

    assert_equal(MULT, TestModel::Table.attributes[:vals][:multiplicity], "has multiplicity")
    assert_equal(DESC, TestModel::Table.attributes[:vals][:description], "has description")

    mate_t = TestModel::ReferencingType.attributes[:mate]
    assert(mate_t[:type] == TestModel::BasicType)

    assert(contains(TestModel::DerivedType, :more), "has derived attribute")
    assert(contains(TestModel::DerivedType, :mate), "has derived attribute")
    assert(contains(TestModel::DerivedType, :id), "has derived attribute")
  end


  def test_model
    assert_equal(1, TestModel::TESTMODEL.contents[:table][0].attributes[:vals][0], "has vals")
    assert_equal(2, TestModel::TESTMODEL.contents[:table][0].attributes[:vals][1], "has vals")
    assert_equal(:content, TestModel::TESTMODEL.contents[:referencingtype][0].attributes[:mate].attributes[:id], "has vals")
    assert_equal(:content, TestModel::TESTMODEL.contents[:referencingtype][0].mate.id, "has vals")

    TestModel.new :T2 do
      table do
        for i in 7..9
          vals i
        end
      end
    end

    assert_equal(7, TestModel::T2.table[0].vals[0], "block iterate")
    assert_equal(8, TestModel::T2.table[0].vals[1], "block iterate")

  end


  def test_kinds
    assert_equal(:Framework, TestModel::TESTMODEL.kindly[0].kind, "kinds")

    # TODO: assertion on strings that aren't in the selection list
    # assert_raise() do
    #   TestModel.new :T3 do
    #     kindly {kind :KindNotValid}
    #   end
    # end
  end

  private

  def contains(type, attr)
    type.attributes.keys.one? {|k| k == attr}
  end



end