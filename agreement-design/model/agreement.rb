require_relative '../src/data_model'
require_relative 'party'
require 'date'
include DataModel

domain :Category do

  datatype(:ItemParameter,
           description: "Defines the meaning of Items in Catalogues") {
    attribute :id, String
    attribute :detail, String
    attribute :keyword, String, ZERO_TO_MANY
    attribute :valueMin, String
    attribute :valueMax, String
    attribute :type, String, "One of: String, Currency, Location, Amount"
    attribute :standard, String, "which standard defines the item type, such as UBL2.1"
    attribute :reference, String, "reference within standard, such as UBL2.1"
  }

  datatype(:Agreement,
           description: "General definition of Commercial Agreements") {
    attribute :id, String
    attribute :item_params, Category::ItemParameter, ZERO_TO_MANY, links: Category::ItemParameter
    attribute :version, String, "semantic version id of the form X.Y.Z"
    attribute :start_date, Date
    attribute :end_date, Date
  }

  datatype(:Framework, extends: Category::Agreement,
           description: "A kind of Framework used for calloffs, composed of Lots") {
    attribute :fwk_number, String, "Such as the RM number"
  }

  datatype(:Lot, extends: Category::Agreement) {
    attribute :fwk_id, String, "Part of framework with this id (not fwk_no)", links: Category::Framework
  }

  datatype(:Item,
           description: "Something offered to a buyer as part of a contract."\
                        "Items are defined in Catalogues.") {
    attribute :id, String, "Item id, possibly a concatentation of the standard (in params) and the catalogue and an incrementatl id?"
    attribute :params, String, links: Category::ItemParameter
    attribute :description, String
    attribute :value, String
  }

  datatype(:Catalogue,
           description: "A collection of items that can be bought via an Agreement.") {
    attribute :id, String
    attribute :items, Category::Item, ZERO_TO_MANY, links: Category::Item
    attribute :agreement_id, String, links: Category::Agreement
  }

  datatype(:Offer,
      description: "")  {
    attribute :id, String, "Offer id, probably a UUID"
    attribute :item_id, String, links: Category::Item
    attribute :catalogue_id, String, links: Category::Catalogue
    attribute :supplier_id, String, links: Parties::Supplier
    attribute :description, String, "Description of the offer"
  }

  datatype(:Award,
           description: "") {
    attribute :buyer_id, String, links: Parties::Buyer
  }

end

