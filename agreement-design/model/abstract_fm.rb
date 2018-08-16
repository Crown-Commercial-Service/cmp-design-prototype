require_relative 'abstract_agreement'

Category.new :FM do

  FM_ID = "FM"
  framework do
    id FM_ID
    fwk_number "RM8330"
    description "This agreement is for the provision of Facilities Management"
    # start_date Date
  end

  lot do
    id "#{FM_ID}.1a"
    fwk_id FM_ID
    description "£0M-£7M" # TODO: need to put this constraint in the lot somehow
    item do
      id "#{FM_ID}.1a-C.3"
      name "environmental cleaning service"
      detail do
        id "price-per-area"
        type :Currency
        standard "CCS-building-area-method"
        reference "per square metre"
      end
      detail do
        id "sector"
        type :Picklist
        option "central"
        option "school"
        standard "CCS-FM-sectornames"
      end
    end
  end

  catalogue do
    id "FM catalogue"
    item do
      param "#{FM_ID}.1a-C.3"
      variable { param "price-per-area"; value "£50"}
      variable { param "sector"; value "central"}
    end
    item do
      param "#{FM_ID}.1a-C.3"
      variable { param "price-per-area"; value "£45"}
      variable { param "sector"; value "schools"}
    end

    offer do
      supplier_id "XYZ corp"
      # variable { param "location"; value "london"}

      item_id "#{FM_ID}.1a-C.3"
      variant do
        variable { param "price-per-area"; value "£30"}
        variable { param "sector"; value "central"}
        variable { param "location"; value "london"}
      end
      variant do
        variable { param "price-per-area"; value "£20"}
        variable { param "sector"; value "schools"}
      end
    end
  end

end



