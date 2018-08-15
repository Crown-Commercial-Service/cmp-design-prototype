require_relative '../src/data_model'
include DataModel

domain :TestModel do

  datatype(:ArrayParam,
           description: "Thing") {
    attribute :thingname, String
  }

  datatype(:ComplexType,
           description: "Thing with things") {
    attribute :string, String
    attribute :things, TestModel::ArrayParam, ZERO_TO_MANY
    attribute :thing_id, String, ZERO_TO_MANY, links: TestModel::ArrayParam
    attribute :strings, String, ZERO_TO_MANY
  }

  datatype(:AnotherType,
           description: "Thing with things") {
    attribute :string, String
  }
end

TestModel.new :TEST do

  complextype do
    string "ID1"
    things do
      thingname "thing1"
    end
    things do
      thingname "thing2"
    end
  end


  anothertype do
    string "Anotherthing"
  end
end

