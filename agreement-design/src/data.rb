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

    map = models_to_data(models)

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