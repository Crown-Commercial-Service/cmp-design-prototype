require_relative 'transform'
include Transform

class Document < Output

  def initialize dir, name
    super File.join(dir, "doc"), name, "md"
  end

  def document *models
    file do |file|
      transform_datamodel(
          {
              :before_model => lambda do |model: |
                file.print %Q!# Model: #{model.name} \n!
              end,
              :before_group => lambda do |name: |
                file.print %Q!## #{name}\n!
              end,
              :before_type => lambda do |type:, depth: 0, index:, total:|
                file.print %Q!####{'#' * depth} #{type.class.typename} - #{type.name} \n!
              end,
              :attribute => lambda do |id:, val:, depth: 0, type: nil, index:, total:|
                file.print %Q!#{"  " * depth} - #{id} #{val}\n!
              end
          }, *models)
    end
  end

  def document_metamodel *models
    file do |file|
      transform_metamodel(
          {
              before_model: lambda do |model:|
                file.print %Q!\# Data model: #{model}\n!
              end,
              before_group: lambda do |group|
                file.print %Q!\# #{group.class}: #{group.name}\n!
                if (group.respond_to?(:description))
                  file.print %Q! #{group.description}\n!
                end
              end,
              before_type: lambda do |type:, depth:, index:, total:|
                file.print "## #{type.typename}"
                if type.extends
                  file.print " extends #{type.extends}"
                end
                file.print "\n  #{type.description}\n\n"
                file.print "|attribute|type|multiplicity|description|\n"
                file.print "|---------|----|------------|-----------|\n"
              end,
              attribute: lambda do |id:, val:, type:, depth:, index:, total:|
                file.print "|#{val[:name]}|#{type_and_link(val)}|#{pretty_multiplicity(val)}|#{val[:description]}|\n"
              end,
              before_codes: lambda do |model:|
                file.print "# Codes\n"
              end,
              code: lambda do |model:, code:|
                file.print "## #{code[:id]} #{code[:title]}\n"
                file.print "#{code[:description]}\n"
                file.print "#{code[:uri]}\n"
              end
          }, *models)
    end
  end


  private

  def type_and_link(val)
    if val[:links]
      return "#{val[:type]} -> #{val[:links]}"
    end
    val[:type]
  end

end