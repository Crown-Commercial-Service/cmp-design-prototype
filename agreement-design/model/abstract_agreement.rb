require_relative '../src/data_model'
require_relative 'party'
include DataModel

domain :Category do

  datatype(:VariableParameter,
           description: "Defines the meaning of Items in Catalogues") {
    attribute :id, String
    attribute :detail, String
    attribute :valueMin, String
    attribute :valueMax, String
    attribute :option, String, "pick from one", ZERO_TO_MANY
    attribute :type, String, "One of: String, Currency, Location, Amount, Document"
    attribute :default, String
    attribute :standard, String, "which standard defines the item type, such as UBL2.1"
    attribute :reference, String, "reference within standard, such as UBL2.1/"
  }

  datatype(:ItemParameter,
           description: "Defines the meaning of Items in Catalogues") {
    attribute :id, String
    attribute :name, String
    attribute :detail, String
    attribute :keyword, String, ZERO_TO_MANY
    attribute :standard, String, "which standard defines the item type, such as UBL2.1"
    attribute :code, String, ZERO_TO_MANY, "codes within standard, such as UBL2.1"
    attribute :detail, Category::VariableParameter, ZERO_TO_MANY,
              "define the fixed variables for the item on the agreement"
    attribute :option, Category::VariableParameter, ZERO_TO_MANY,
              "define the optional offer variables for offers on the item"
  }

  datatype(:Agreement,
           description: "General definition of Commercial Agreements") {
    attribute :id, String
    attribute :description, String
    attribute :item, Category::ItemParameter, ZERO_TO_MANY,
              "item params describe the composition of the agreement"
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

  datatype(:Variable,
           description: "detail for an item or need") {
    attribute :index, String, "optional index where many variable exist for the same parameter"
    attribute :value, String
    attribute :param, String, ZERO_TO_MANY, links: Category::VariableParameter
  }

  datatype(:Item,
           description: "Something offered to a buyer as part of a contract."\
                        "Items are defined in Catalogues.") {
    attribute :id, String, "Item id, possibly a concatentation of the standard (in params) and the catalogue and an incrementatl id?"
    attribute :param, String, links: Category::ItemParameter
    attribute :description, String
    attribute :variable, Category::Variable, ZERO_TO_MANY
  }

  datatype(:Offer,
           description: "") {
    attribute :id, String, "Offer id, probably a UUID"
    attribute :item_id, String, links: Category::Item
    attribute :variant, Category::Item, ZERO_TO_MANY
    attribute :supplier_id, String, links: Parties::Supplier
    attribute :description, String, "Description of the offer"
  }

  datatype(:Catalogue,
           description: "A collection of items that can be bought via an Agreement.") {
    attribute :id, String
    attribute :item, Category::Item, ZERO_TO_MANY
    attribute :agreement_id, String, links: Category::Agreement
    attribute :offer, Category::Offer, ZERO_TO_MANY
  }

  datatype(:Award,
           description: "") {
    attribute :buyer_id, String, links: Parties::Buyer
    attribute :offer_id, String, ZERO_TO_MANY, links: Category::Offer
  }

end

