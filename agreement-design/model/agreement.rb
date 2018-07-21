
require_relative '../src/data_model'
require 'pp'
include DataModel

domain :Agreements do

  datatype :Agreement do
    attribute :id, String
  end

  datatype :Framework, Agreements::Agreement do
    attribute :fwk_id, String, "RM number"
  end

  datatype :Lot, Agreements::Agreement do
    attribute :fwk_id, String, "Part of framework", :links => :Framework
  end

  datatype :Item do
    attribute :id, String
    attribute :detail, String
  end

  datatype :Catalogue do
    attribute :id, String
    attribute :items, Agreements::Item, ONE_TO_MANY
  end
end

