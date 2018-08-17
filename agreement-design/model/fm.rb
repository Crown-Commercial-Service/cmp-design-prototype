require_relative 'agreement'

domain :FM do
  datatype(:FM_Offering, extends: Category::Offering,
           description: " An offer for FM elements ") do
    attribute :sc_cleared, String
  end
end

Category.new :Frameworks do

  FM_ID = "FM"
  agreement do
    kind :Framework
    id FM_ID
    fwk_number "RM8330"
    description "This agreement is for the provision of Facilities Management"
    start_date date(2018, 10, 01)
  end

  ENV_CLEANING = "#{FM_ID}.1a-C.3"
  agreement do
    kind :Lot
    id "FM lot 1"
    name "low-to-mid value Facilities Management Lot"
    part_of_id FM_ID
    min_value 0
    max_value 70000000
    item_types do
      id ENV_CLEANING
      name "environmental cleaning service"
      units :Currency
      code "CCS-building-area-method"
      keyword "cleaning"
      keyword "washing"
      keyword "janitor"
    end
  end
  # # FM_Domain::FM_Offering.new("fm-offering") do
  # offering do
  #   supplier_id "XYZ corp"
  #   name "XYZ's nifty school cleaning service"
  #   agreement_id FM_ID
  #   location_id UK.name
  #   sector :Education
  #   item do
  #     type ENV_CLEANING
  #     value 3000
  #   end
  # end

end

FM.new :FM_catalogue do
  fm_offering do
    supplier_id "XYZ corp"
    name "XYZ's nifty school cleaning service"
    agreement_id FM_ID
    location_id UK.name
    sector :Education
    sc_cleared "TRUE"
    item do
      type ENV_CLEANING
      value 3000
    end
  end

end








