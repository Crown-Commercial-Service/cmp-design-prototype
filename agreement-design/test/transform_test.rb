require 'test/unit'
require_relative '../src/doc'
require_relative 'test_model'
include DataModel

class TransformTest < Test::Unit::TestCase

  def test_model
    the_model = TestModel::TESTMODEL
    transform_datamodel(
        {
            before_model: lambda do |model:|
              assert_equal(model, the_model)
            end,
            before_group: lambda do |name:, depth: 0|
              puts "before group #{name}, #{depth}"
              assert(name = "framework" || name = "lot")
              return :group_context
            end,
            after_group: lambda do |name:, depth:, before:|
              puts "after group #{name}, #{depth}"
              assert(before == :group_context)
            end,
            before_type: lambda do |type:, depth:, index:, total:|
              puts "before type  #{type}, #{depth}"
              assert(type.class < DataType)
              return :type_context
            end,
            after_type: lambda do |type:, depth:, before:|
              puts "after type  #{type}, #{depth}"
              assert(before == :type_context)
            end,
            before_array: lambda do |name:, decl:, depth:, total:|
              puts "before array #{name}, #{decl}, #{depth}"
              assert(decl.class <= Array)
              return :array_context
            end,
            after_array: lambda do |index:, decl:, depth:, before:|
              puts "after array #{index}, #{decl}, #{depth}, #{before}"
              assert(before == :array_context)
            end,
            attribute: lambda do |id:, val:, depth: 0, type: 0, index:, total:|
              puts "attribute #{id}, #{val}, #{depth}, #{type}"
            end,
        },
        the_model)
  end

  def test_metamodel
    the_model = TestModel
    transform_metamodel(
        {
            before_model: lambda do |model:|
              assert_equal(model, the_model)
            end,
            before_group: lambda do |name:, depth:|
              assert(false, "shouldn't be called")
            end,
            after_group: lambda do |name:, depth:, before:|
              assert(false, "shouldn't be called")
            end,
            before_type: lambda do |type:, depth:, index:, total:|
              puts "before type #{type}, #{depth}"
              assert(type <= DataType)
              return :type_context
            end,
            after_type: lambda do |type:, depth:, before: nil|
              puts "after type #{type}, #{depth}"
              assert(before == :type_context)
            end,
            before_array: lambda do |index:, decl:, depth:|
              assert(false, "shouldn't be called")
            end,
            after_array: lambda do |index:, decl:, depth:, before:|
              assert(false, "shouldn't be called")
            end,
            attribute: lambda do |id:, val:, depth:, type:, index:, total:|
              puts "attribute #{id}, #{val}, #{depth}, #{type}"
            end,
        },
        the_model)
  end

  def test_models_to_data
    data= models_to_data( TestModel::TESTMODEL)
    puts data
    assert_equal "ID1", data[:complextype][0][:string]
  end

  def test_metamodels_to_data
    data= metamodels_to_data( TestModel)
    # pp TestModel
    pp data
    assert_equal :strings,  data[:ComplexType][:strings][:name]
  end
end