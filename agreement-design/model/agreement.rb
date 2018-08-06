
require_relative '../src/data_model'
require 'pp'
include DataModel

domain :Parties do
  datatype :Party do

  end

  datatype :Supplier, Parties::Party do

  end
end

domain :Agreements do

  datatype :Agreement do
    attribute :id, String
  end

  datatype :Framework, Agreements::Agreement do
    attribute :fwk_id, String, "RM number"
  end

  datatype :Lot, Agreements::Agreement do
    attribute :fwk_id, String, "Part of framework", :links => Agreements::Framework
  end

  datatype :ItemParameter do
    attribute :id, String
    attribute :detail, String
    attribute :valueMin, String
    attribute :valueMax, String
    attribute :type, String
  end

  datatype :Item do
    attribute :id, String
    attribute :params, String, :links => Agreements::ItemParameter
    attribute :detail, String
    attribute :value, String
  end

  datatype :Catalogue do
    attribute :id, String
    attribute :items, Agreements::Item, ONE_TO_MANY
    attribute :agreement, String, :links => Agreements::Agreement
  end

  datatype :Offer, Agreements::Agreement do
  end

end

