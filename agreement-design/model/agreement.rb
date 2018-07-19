
require_relative '../src/data_model'
require 'pp'
include DataModel

domain :Records do

  datatype :Agreement do
    attribute :id, String
  end

  datatype :Framework, DataModel::Records::Agreement do
    attribute :fwk_id, String, "RM number"
  end

  datatype :Catalogue do
    attribute :id, String
    attribute :items, String, 0..50
  end
end

for type in DataModel::Records.types.values do
  pp type.name
  pp type.attributes
end