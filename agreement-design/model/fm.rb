require_relative 'agreement'

Category.new :FM do

  FM_ID= "FM"
  framework do
    id FM_ID
    item do
      id "service"
      detail "FM supports a number of services"
      standard "which standard does this comply with?"
      code "which bits of the standard?"

    end
  end
end

puts Category::FM.contents[:lot]


