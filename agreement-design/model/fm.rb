require_relative 'agreement'

domain(:FM_Offerings) {
  datatype(:FM_Offering, extends: Agreements::Offering,
           description: " An offer for FM elements ") {
    attribute :sc_cleared, String

  }
}

Agreements.new(:FM_Agreements) {

  FM_ID = "RM3830"

  fm_coding = lambda do
    pillar :Buildings
    status :Live
    category :Workplace
  end

  FM= agreement {
    kind :Framework
    id FM_ID
    include &fm_coding
    version "0.1.0"
    description "This agreement is for the provision of Facilities Management"
    start_date date(2018, 10, 01)
    min_value 0
    max_value 12000000000
  }

  FM_LOT1a = "#{FM_ID}.1a"

  agreement {
    kind :Lot
    id FM_LOT1a
    name "low-to-mid value Facilities Management Lot"
    part_of_id FM_ID
    include &fm_coding
    version "0.1.0"
    description "This agreement is for the provision of Facilities Management"
    start_date date(2018, 10, 01)
  }

  ENV_CLEANING= "cleaning"
  cleaning = itemtype {
    id ENV_CLEANING
    scheme_id :CCS
    unit :Commission
    code "CCS-building-area-method"
    keyword "cleaning"
    keyword "washing"
    keyword "janitor"
  }

  agreement {
    kind :Lot
    id "FM lot 1"
    name "low-to-mid value Facilities Management Lot"
    part_of_id FM_ID
    min_value 0
    max_value 70000000
    version "0.1.0"
    cnew = item_type cleaning
  }

}

FM_Offerings.new(:FM_Catalogue) {
  fm_offering {
    supplier_id "XYZ corp"
    name "XYZ's nifty school cleaning service"
    agreement_id FM_ID
    location_id UK.name
    sector_id :public_education
    sc_cleared "TRUE"
    item {
      type_id ENV_CLEANING
      value 3000
    }
  }
}








