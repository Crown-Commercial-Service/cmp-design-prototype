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

  # @param [object] index - if included, and using :jsonlines, will call index on each item (as a hash) and prepend the line.
  # @param [string] select - if given this will select out the type, eg agreements, and discard the rest
  def output *models, index: nil, select: nil

    map = models_to_data(models)


    file do |file|
      if fmt == :jsonlines
        select ? selection = [select] : selection = map.keys
        for type in selection
          for decl in map[type]
            if (index)
              file.print (JSON.generate(index.call(decl)))
              file.print("\n")
            end
            file.print(JSON.generate(decl))
            file.print("\n")
          end
        end
      elsif fmt == :json
        select ? map = map[select] : map
        file.print(JSON.generate(map))
      elsif fmt == :yaml
        select ? map = map[select] : map
        file.print(map.to_yaml)
      else
        raise "unknown data file format"
      end
    end
  end

end

# given an offer object return an index object
# Maybe: turn this into a datatype map, not an object map, so we can access type metadata

def index_offering_for_elasticsearch
  return lambda do |offer|
    var = offer[:name].gsub(/(\s+)/, '_')
    return {"index": {"_id": "#{var}"}}
  end
end

def index_agreement_for_elasticsearch
  return lambda do |id|
    var = id[:id].gsub(/(\s+)/, '_')
    return {"index": {"_id": "#{var}"}}
  end
end


private

def indent(depth)
  "  " * depth
end