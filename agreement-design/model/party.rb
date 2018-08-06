require_relative '../src/data_model'
include DataModel

domain :Parties do

  datatype :Party do
    attribute :id, String, "UUID or Salesforce ID?"
  end

  datatype :Supplier, Parties::Party do

  end

  datatype :Buyer, Parties::Party do

  end
end
