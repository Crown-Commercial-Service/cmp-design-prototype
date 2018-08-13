require 'fileutils'
require_relative 'transform'
include Transform

class Diagram < Output

  def dotfile
    File.join(diagram_path, "#{self.name}.dot")
  end

  def jpgfile
    File.join(image_path, "#{self.name}.jpg")
  end

  def describe *models

    FileUtils.mkpath diagram_path
    FileUtils.mkpath image_path
    File.open(self.dotfile, "w") do |file|
      # nodes
      file.print "strict digraph {\n"

      transform_metamodel(
          {
              before_model: lambda do |model:|
                file.print "subgraph cluster_#{model} {\n"
                file.print "node [shape=plaintext margin=0];\n"
                file.print "label=#{model};\n"
              end,
              after_model: lambda do |model:, before:|
                file.print "}\n"
              end,
              before_type: lambda do |type:, depth:|
                file.print %Q("#{type.typename}" [label=<<table BORDER="1" CELLBORDER="0" CELLSPACING="0"><TH><TD>#{type.typename}</TD></TH>)
              end,
              after_type: lambda do |type:, depth:, before:|
                file.print "</table>"
                file.print ">];\n"
              end,
              attribute: lambda do |id:, val:, depth:, type:|
                file.print %Q(<TR><TD ALIGN="LEFT">-#{id}</TD></TR>)
              end,
          },
          *models
      )
      #  links
      transform_metamodel(
          {
              before_type: lambda do | type:, depth: |
                if type.superclass < DataType
                  link(file, type.typename, type.superclass.typename,
                       label: "extends",
                       arrowhead: "none",
                       arrowtail: "normal")
                end
              end,
              :attribute => lambda do |id:, val: , depth: 0, type:|
                if val[:links]
                  contains = (val[:type] < DataType)
                  link(file, type.typename, val[:links].typename,
                       label: %Q!#{contains ? "{contains} " : ""}#{val[:name]}!,
                       arrowhead: contains ? "none" : "open",
                       arrowtail: contains ? "diamond" : "none")
                end
              end,
          },
          *models
      )
      file.print "}\n"
    end

    unless system("dot -Tjpg #{self.dotfile} > #{self.jpgfile}")
      puts "Error: couldn't create jpeg: #{self.jpgfile}"
    end

  end

  def att_detail(att)
    mult = att[:multiplicity]
    mstring = (mult == ZERO_TO_MANY ? "[*]" : mult == ONE_TO_MANY ? "[1..*]" : mult == SINGLE ? "" : "[#{mult.to_s}]")
    "#{att[:name]} #{mstring}"
  end

  def modelname m
    m.name.gsub(/^#{DataModel.name}::/, "").gsub /::/, "-"
  end

  def typename t
    t.name.gsub(/^#{t.domain}::/, "").gsub /::/, "-"
  end

  private

  def image_path
    File.join(self.path, "images")
  end

  def diagram_path
    File.join(self.path, "diagrams")
  end

  def link file, el1, el2, label: el2, arrowhead: nil, arrowtail: nil
    ah = arrowhead ? %Q!arrowhead = "#{arrowhead}"! : ""
    at = arrowtail ? %Q!arrowtail = "#{arrowtail}"! : ""
    file.print %Q!"#{el1}" -> "#{el2}" [label="#{label}" #{ah} #{at} ];\n!
  end

end