require_relative '../src/data_model'
include DataModel

domain(:Parties) {

  datatype(:Sector, description: "
  Hierarchy of sector codes delineating the party organisation
  ") {
    attribute :name, String
    attribute :description, String
    attribute :subsector, :Sector, ZERO_TO_MANY
  }

  datatype(:Party, description: "
  The party is used to identify buyers and suppliers. Since some organisations act as
both buyers and suppliers we use the same record for both, but most organisations will
be one or the other. The onvolvement of the party with an agreement determine  the role in
that contenxt.
Details still to be added") {
    attribute :id, String, "URN, should match salesforce ID; master key"
    attribute :parent_org_id, String, "URN, should match salesforce ID", links: :Party
    attribute :duns, String, ZERO_OR_ONE, "Dunn & Bradstreet number - usually suppleirs only"
    attribute :urn, String, ZERO_OR_ONE, "Government URN, of the form 100001234"
    attribute :company_reg_number, String, ZERO_OR_ONE
    attribute :org_name, String
    attribute :sector, :Sector, ZERO_TO_MANY
    attribute :trading_name, String, ZERO_OR_ONE, "Salesforce only stores for supplier"
    # Supplier registration
    attribute :supplier_registration_completed, Date, "The party is a supplier who has completed registration"
    # Buyer registration
    attribute :buyer_registration_completed, Date, "The party is a supplier who has completed registration"
    attribute :spend_this_year, String, ZERO_OR_ONE, "Salesforce only stores for buyer"
    attribute :documents_url, String, ZERO_OR_ONE, "Salesforce links to google drive for this supplier; we will move to S3 in due course"
    attribute :account_manager_id, String, ZERO_OR_ONE, "Who manages the account for CCS"
  }

  datatype(:Address, description: "Address should include at least address line 1 and ideally post code.
will contain lat/long if we have derived it.
  ") {
    attribute :street, String
    attribute :address_2, String, ZERO_OR_ONE
    attribute :town, String, ZERO_OR_ONE
    attribute :county, String, ZERO_OR_ONE
    attribute :country, String, ZERO_OR_ONE
    attribute :postcode, String, ZERO_OR_ONE
    attribute :latitutde, String, ZERO_OR_ONE, "Location from the address for geo search"
    attribute :longtitude, String, ZERO_OR_ONE, "Location from the address for geo search"
  }

  datatype(:Contact, description: "
  A way of contacting a party. Store contacts in a safe identity store. Do not store personal details elsewhere.
  ") {
    attribute :id, String, "a newly minted UUID for CMp"
    attribute :salesforce_id, String, "a Salesforce Contact_ID column point; of the form CONT-000122663"
    attribute :party_id, String, "contact is a link for this party", links: :Party
    attribute :role, String, ZERO_TO_MANY, "role for CMp"
    attribute :first_name, String
    attribute :last_name, String
    attribute :title, String, ZERO_OR_ONE, "Salesforce; not sure what the constrainst are"
    attribute :job_title, String, ZERO_OR_ONE, "Salesforce; free text"
    attribute :department, String, ZERO_OR_ONE, "Salesforce - department within org, rather than gov"
    attribute :address, :Address, ZERO_OR_ONE, "address of the contact point"
    attribute :phone, String, ZERO_TO_MANY, "phone of the contact point; salesforce only supports one"
    attribute :email, String, ZERO_TO_MANY, "email of the contact point; salesforce only supports two"
    attribute :origin, String, ZERO_OR_ONE, "from Salesforce - where the data was entered"
    attribute :notes, String, ZERO_OR_ONE, "from Salesforce"
    attribute :status, String, ZERO_OR_ONE, "from Salesforce, 'Active'"
    attribute :user_research_participane, String, ZERO_OR_ONE, "Y/N: from Salesforce" #TODO implement Boolean
    attribute :not_to_receive_ccs_emails, String, ZERO_OR_ONE, "Y/N: from Salesforce" #TODO implement Boolean
    attribute :contact_owner, String, ZERO_OR_ONE, "from Salesforce"
  }

}

Parties.new :SECTORS do

  # made up codes
  ALL_UK_GOV = sector do
    name :All_UK_gov
    description "All UK Government including Central, Wider, and others"
    CENTRAL = subsector do
      name :Central_Gov; description "Central Government";
      subsector do
        name :example_dept; description "E.g. a dept";
      end
    end
    WIDER = subsector do
      name :Wider_Gov; description "Wider Government";
      ED= subsector do
        name :education; description "All education";
        PUB_ED = subsector do
          name :public_education; description "Public education";
        end
      end
    end
  end
end