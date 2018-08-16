require 'test/unit'
require_relative '../src/doc'
require_relative 'test_model'
include DataModel

class DocTest < Test::Unit::TestCase

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
            before_type: lambda do |type:, depth:|
              puts "before type  #{type}, #{depth}"
              assert(type.class < DataType)
              return :type_context
            end,
            after_type: lambda do |type:, depth:, before:|
              puts "after type  #{type}, #{depth}"
              assert(before == :type_context)
            end,
            before_array: lambda do |index:, decl:, depth: |
              puts "before array #{index}, #{decl}, #{depth}"
              assert(decl.class <= Array)
              return :array_context
            end,
            after_array: lambda do |index:, decl:, depth:, before:|
              puts "after array #{index}, #{decl}, #{depth}, #{before}"
              assert(before == :array_context)
            end,
            attribute: lambda do |id: , val: , depth: 0, type: 0|
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
            after_group: lambda do |name:, depth: , before:|
              assert(false, "shouldn't be called")
            end,
            before_type: lambda do | type:, depth:|
              puts "before type #{type}, #{depth}"
              assert(type <= DataType)
              return :type_context
            end,
            after_type: lambda do | type:, depth:, before: nil|
              puts "after type #{type}, #{depth}"
              assert(before == :type_context)
            end,
            before_array: lambda do |index:, decl:, depth: |
              assert(false, "shouldn't be called")
            end,
            after_array: lambda do |index:, decl:, depth:, before: |
              assert(false, "shouldn't be called")
            end,
            attribute: lambda do |id:, val:, depth:, type: |
              puts "attribute #{id}, #{val}, #{depth}, #{type}"
            end,
        },
        the_model)
  end
end