

require_relative 'agreement'

fm= Category.new :FM do
  FM_ID= "RM123"
  framework do
      id FM_ID
      fwk_id FM_ID
  end

end

puts Category::FM.contents[:framework].to_s


