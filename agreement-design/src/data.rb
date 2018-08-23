require_relative 'transform'
require 'pp'
require 'json'

include Transform

class DataFile < Output

  def initialize dir, name
    super File.join(dir, "data"), name, "json"
  end

  def json *models

    map = Hash.new
    stack = [map]
    transform_datamodel(
        {
            :before_group => lambda do |name:, depth:|
              last = stack.last
              n= Array.new
              last[name] = n
              stack.push(n) # add a new container to the stack to use next
            end,
            :before_type => lambda do |type:, depth:, index:, total:|
              last = stack.last
              n= Hash.new
              stack.push(n) # add a new container to the stack to use next
              if last.class <= Hash
                last[type.name] = n
              elsif last.class <= Array
                last.push(n)
              end
            end,
            :before_array => lambda do |name:, decl:, depth:, total:|
              last = stack.last
              n= Array.new
              last[name] = n
              stack.push(n) # add a new container to the stack to use next
            end,
            :attribute => lambda do |id:, val:, depth:, type:, index:, total:|
              last = stack.last
              if last.class <= Hash
                last[id] = val
              elsif last.class <= Array
                last.push val
              end
            end,
            :after_group => lambda do |name:, depth:, before:|
              stack.pop
            end,
            :after_type => lambda do |type:, depth:, before:|
              stack.pop
            end,
            :after_array => lambda do |index:, decl:, depth:, before: nil|
              stack.pop
            end,
        }, *models)

    file do |file|
      file.print(JSON.generate(map))
    end
  end

end

private

def indent(depth)
  "  " * depth
end