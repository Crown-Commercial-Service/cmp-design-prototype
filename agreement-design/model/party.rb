require_relative '../src/data_model'
include DataModel

domain(:Parties) {

  datatype(:Party, description: "
  The party is used to identify buyers and suppliers. Since some organisations act as
both buyers and suppliers we use the same record for both, but most organisations will
be one or the other. The onvolvement of the party with an agreement determine  the role in
that contenxt.
Details still to be added") {
    attribute :id, String, "UUID or Salesforce ID?"
    #TODO add all the usual fields
    # Supplier registration
    attribute :supplier_registration_completed, Date
    # Buyer registration
    attribute :buyer_registration_completed, Date
  }
}
