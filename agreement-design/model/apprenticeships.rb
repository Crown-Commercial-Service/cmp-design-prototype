require_relative 'agreement'
require_relative 'geographic'
require_relative 'party'
require 'csv'

APPRENTICESHIPS_FRAMEWORK_ID = "RM6102"
APPRENTICESHIPS_TRAINING_ID = "#{APPRENTICESHIPS_FRAMEWORK_ID}.2"

# Apprenticeships item coding
QUALIFICATIONS = [:Qualification_One, :Qualification_Two]
PATHWAY_SECTOR = Selection(:Central_Gov, :education)
LEVEL = Selection (:SomeLevel)
BAND = Selection(:LowBands, :HighBand)
REGION = Selection(:UK, :UKC1) # should include all the NUTS codes
ABILITY_TO_BESPOKE = Selection(:Bespokable, :NotBespokable)

def at_code(sector, level, band, region, bespokeable)
  "#{sector}-#{level}-#{band}-#{region}-#{bespokeable}"
end

Agreements.new(:Apprenticeships_Agreements) {

  AT = agreement {
    kind :Framework
    name "Apprenticeships - get desc from SF"
    long_name name
    id APPRENTICESHIPS_FRAMEWORK_ID
    pillar :People
    status :Live
    category :Workforce
    version "0.1.0"
    description "This agreement is for the provision of APPRENTICESHIPS"
    start_date date(2018, 8, 30)
    original_end_date date(2018, 8, 30)
    end_date original_end_date
    offerType
  }

  agreement {
    kind :Lot
    id APPRENTICESHIPS_TRAINING_ID
    name "Apprenticeships "
    long_name name
    part_of_id APPRENTICESHIPS_FRAMEWORK_ID
    pillar AT.pillar
    category AT.category
    offerType "ApprenticeshipsOfferings::AT_Offering"
    version "0.1.0"

    item_type {
      description "Train builders for schools"
      id at_code(:education, :SomeLevel, :LowBand, :UKC1, :NotBespokable)
      keyword "school builders"
      keyword "builders"
    }
  }

}

domain(:ApprenticeshipsOfferings) {

  datatype(:AT_Offering, extends: Agreements::Offering,
           description: " An offer for AT ") {
    attribute :entry_requirements, String, ZERO_TO_MANY, "Standard requirements of Entry to the Standard / Framework"
    attribute :outcomes, String, ZERO_TO_MANY, "Potential career paths, Job Roles"
    attribute :qualifications_required, String, ZERO_TO_MANY, " link to code identifying a qualification.
Qualifications Required	Qualification required to attend the training"
    attribute :qualifications_awarded, String, ZERO_TO_MANY, " link to code identifying a qualification.
QQualifications Awarded	Qualifications outcomes apprentices will receive"
    attribute :minimum_order_numnber, Integer, "number of people who can be placed. "
    attribute :maximum_order_numnber, Integer, "number of people who can be placed. "
    attribute :dates, Date, ZERO_TO_MANY, "Dates within academic year - presumably updated every year?"
    attribute :branch_name, String, "branch name from which the offer is supplied"
    attribute :branch_contact_id, String, "links to contact at the address", links: Parties::Contact
    attribute :branch_location, String, "postcode of branch"
  }
}

domain(:ApprenticeshipsSupplierDetails) {

  datatype(:AT_Supplier, description: "Extra supplier details periodically given for supplier, that may affect buyer searches") do
    attribute :esfa_provider_type, Selection(:Training, :EPA, :Both), "Type of provider"
    attribute :esfa_ukprn, String, "ESFA Provider reference number"
    attribute :overall_ofsted_rating, String, "String, source: :OFFSTED"
    attribute :esfa_provider_overview, String, "Overview of provider on ESFA website"
    attribute :achievement_rates_provider, String, "Currnt Provider Achievement Rates"
    attribute :cyber_security_standards, String, "Cyber security standards (Y / N)"
    attribute :subcontracting, String,  "Is the supplier subcontracting (Y / N)"
  end
}


