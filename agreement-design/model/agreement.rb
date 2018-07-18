require_relative '../src/data_model'
require 'pp'
include DataModel

d = domain :Records do

  datatype :Agreement do
    attribute :id, String
  end

  datatype :Catalogue do
    attribute :id, String
    attribute :items, String, [0..50]
  end
end

pp DataModel::Records.types
for type in DataModel::Records.types.values do
      pp type.attributes
end