require 'fileutils'
require_relative 'doc'


class TableElement < Element
  def initialize file, node
    super(file)
    @node = node
    pput %Q("#{@node}" [label=<<table BORDER="1" CELLBORDER="0" CELLSPACING="0"><TH><TD>#{@node}</TD></TH>)
    @items = []
  end

  def item i
    @items << i
    self.pput %Q(<TR><TD ALIGN="LEFT">-#{i}</TD></TR>)
  end

  def finish
    # self.pput " " << @items.join( ",")
    self.pput "</table>"
    self.pput ">];\n"
  end


end

class Graph < Element
  def initialize file
    super(file)
    self.pput "strict digraph {\n"
  end

  def finish
    self.pput "}\n"
  end

end

class SubGraph < Element
  def initialize file, model
    super(file)
    self.pput "subgraph cluster_#{model} {\n"
    self.pput "node [shape=plaintext margin=0];\n"
    self.pput "label=#{model};\n"
  end

  def finish
    self.pput "}\n"
  end

end

class Links < Element

  def link el1, el2, label: el, arrowhead: nil, arrowtail: nil
    ah = arrowhead ? %Q!arrowhead = "#{arrowhead}"! : ""
    at = arrowtail ? %Q!arrowtail = "#{arrowtail}"! : ""
    pput %Q!"#{el1}" -> "#{el2}" [label="#{label}" #{ah} #{at} ];\n!
  end

end

class Diagram < Doc

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
      graph = Graph.new(file)
      for model in models
        subgraph = SubGraph.new(file, modelname(model))
        for type in model.types.values
          table = TableElement.new(file, typename(type))
          for att in type.attributes(false).values
            table.item att_detail(att)
          end
          table.finish
        end
        subgraph.finish
      end
      for model in models
        links = Links.new(file)
        for type in model.types.values
          for att in type.attributes(false).keys
            if type.attributes[att][:links]
              contains = (type.attributes[att][:type] < DataType)
              links.link typename(type),
                         typename(type.attributes[att][:links]),
                         label: %Q!#{contains ? "{contains} " : ""}#{type.attributes[att][:name]}!,
                         arrowhead: contains ? "none": "open",
                         arrowtail: contains ? "diamond": "none"
            end
          end
          if type.superclass < DataType
            links.link typename(type),
                       typename(type.superclass),
                       label: "extends",
                       arrowhead: "none",
                       arrowtail:  "normal"
          end
        end
        links.finish
      end
      graph.finish
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

end