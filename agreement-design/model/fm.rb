require_relative 'agreement'

Category.new :FM do

  FM_ID = "RM123"
  framework do
    id FM_ID
    fwk_number FM_ID
    version "1.0.0"
  end

  lot do
    id "1"; fwk_id FM_ID


    ip= Category::ItemParameter.new :item_params, { id: 2}

    item_params do
      id 2;
    end

    item_params= ip
    item_params= ip
  end

  lot do
    id "2"
    fwk_id FM_ID
  end

end

puts Category::FM.contents[:lot]


