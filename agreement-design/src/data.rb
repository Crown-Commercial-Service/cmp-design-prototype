require_relative 'transform'
require 'pp'
require 'json'
require 'yaml'

include Transform

class DataFile < Output

  attr_accessor :fmt

  def initialize dir, name, fmt: :json
    super File.join(dir, "data"), name,
          (fmt == :json ? "json" : (fmt == :jsonlines ? "jsonlines" : "yaml"))
    self.fmt = fmt
  end

  def output *models

    map = Hash.new
    stack = [map]
    transform_datamodel(
        {
            :before_group => lambda do |name:|
              # group all instances of the same type name into the same array in the top level map
              if map[name]
                stack.push(map[name])
              else
                n = Array.new
                map[name] = n
                stack.push(map[name]) # add a new container to the stack to use next
              end
            end,
            :before_type => lambda do |type:, depth:, index:, total:|
              last = stack.last
              n = Hash.new
              stack.push(n) # add a new container to the stack to use next
              if last.class <= Hash
                last[type.name] = n
              elsif last.class <= Array
                last.push(n)
              end
            end,
            :before_array => lambda do |name:, decl:, depth:, total:|
              last = stack.last
              n = Array.new
              if last.class <= Array
                last<< n
              else
                last[name] = n
              end
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
      if fmt == :jsonlines
        for type in map.keys
          for decl in map[type]
            file.print(JSON.generate(decl))
            file.print("\n")
          end
        end
      elsif fmt == :json
        file.print(JSON.generate(map))
      elsif fmt == :yaml
        file.print(map.to_yaml)
      else
        raise "unknown data file format"
      end
    end
  end

end

private

def indent(depth)
  "  " * depth
end