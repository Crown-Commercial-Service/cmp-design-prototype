require_relative 'agreement'
require_relative 'geographic'
require_relative 'party'
require 'csv'

APPRENTICESHIPS_FRAMEWORK_ID = "DON'T KNOW YET"
APPRENTICESHIPS_TRAINING_ID = "#{APPRENTICESHIPS_FRAMEWORK_ID}.2"

# Apprenticeships item coding
QUALIFICATIONS= [ :Qualification_One, :Qualification_Two]
PATHWAY_SECTOR = Selection( :Central_Gov, :education)
LEVEL = Selection (:SomeLevel)
BAND = Selection(:LowBands, :HighBand)
REGION= Selection( :UK, :UKC1) # should include all the NUTS codes
ABILITY_TO_BESPOKE= Selection( :Bespokable, :NotBespokable)

def at_code( sector, level, band, region, bespokeable)
  "#{sector}-#{level}-#{band}-#{region}-#{bespokeable}"
end

Agreements.new(:Apprenticeships_Agreements) {

  AP = agreement {
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
    pillar AP.pillar
    category AP.category
    offerType "SupplyTeacherOfferings::ST_Offering"
    version "0.1.0"

    item_type {
      description "Train builders for schools"
      id at_code( :education, :SomeLevel, :LowBand, :UKC1, :NotBespokable )
      keyword "school builders"
      keyword "builders"
    }
  }


}
