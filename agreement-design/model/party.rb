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
    attribute :org_name, String, "UUID or Salesforce ID?"
    # Supplier registration
    attribute :supplier_registration_completed, Date
    # Buyer registration
    attribute :buyer_registration_completed, Date
  }

  datatype(:Address, description: "Address should include at least addres line 1 and ideally post code.
will contain UPRN if we have derived it.
  ") {
    attribute :address_1, String
    attribute :address_2, String, ZERO_OR_ONE
    attribute :town, String, ZERO_OR_ONE
    attribute :county, String, ZERO_TO_MANY
    attribute :postcode, String, ZERO_TO_MANY
    attribute :uprn, String, ZERO_TO_MANY
  }
  
  datatype(:Contact, description: "
  A way of contacting a party. Store contacts in a safe identity store. Do not store personal details elsewhere.
  ") {
    attribute :id, String, "a UUID for the person or contact point"
    attribute :party_id, String, "contact is a link for this party", links: :Party
    attribute :name, String, "address of the contact point"
    attribute :address, :Address, ZERO_OR_ONE, "address of the contact point"
    attribute :phone, String, ZERO_TO_MANY, "phone of the contact point"
    attribute :email, String, ZERO_TO_MANY, "email of the contact point"
  }

  # TODO add contact links
  # TODO add address
}
