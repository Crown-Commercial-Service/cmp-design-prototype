require_relative '../src/data_model'
include DataModel

domain :Parties do

  datatype :Party do
    attribute :id, String, "UUID or Salesforce ID?"
  end

  datatype :Supplier, extends: Parties::Party do

  end

  datatype :Buyer, extends: Parties::Party do

  end
end
