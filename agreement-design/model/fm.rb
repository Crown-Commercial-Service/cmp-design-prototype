require_relative 'agreement'

Category.new :FM do

  FM_ID = "RM123"
  framework do
    id FM_ID
    fwk_id FM_ID
    version "1.0.0"
  end

  lot do
    id "1"; fwk_id FM_ID
    item_params do
      id 1; valueMin 0; valueMax 100
    end
    item_params do
      id 2; valueMin 0; valueMax 100
    end
  end

  lot do
    id "2"
    fwk_id FM_ID
  end

end

puts Category::FM.contents[:lot]


