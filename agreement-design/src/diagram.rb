require 'fileutils'

class Element
  def initialize file
    @file = file
  end

  def finish
  end

  protected

  def pput(string)
    @file.print string
  end

end

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

  def link el1, el2, label = ""
    pput %Q!"#{el1}" -> "#{el2}" [label=#{label}];\n!
  end

end

class Diagram
  attr_accessor :path, :name

  def initialize path, name
    self.path = path
    self.name = name
  end

  def dotfile
    File.join(self.path, "diagrams", "#{self.name}.dot")
  end

  def jpgfile
    File.join(self.path, "images", "#{self.name}.jpg")
  end

  def describe *models

    FileUtils.mkpath File.join(self.path, "diagrams")
    FileUtils.mkpath File.join(self.path, "images")
    File.open(self.dotfile, "w") do |file|
      graph = Graph.new(file)
      for model in models
        subgraph = SubGraph.new(file, modelname(model))
        for type in model.types.values
          table = TableElement.new(file, typename(type))
          for att in type.attributes.values
            table.item att_detail( att)
          end
          table.finish
        end
        subgraph.finish
      end
      for model in models
        links = Links.new(file)
        for type in model.types.values
          for att in type.attributes.keys
            if type.attributes[att][:links]
              links.link typename(type),
                         typename(type.attributes[att][:links]),
                         type.attributes[att][:name]
            end
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
    mult= att[:multiplicity]
    mstring= (mult == ZERO_TO_MANY ? "[*]" : mult == ONE_TO_MANY ? "[1..*]" : mult == SINGLE ? "": "[#{mult.to_s}]")
    "#{att[:name]} #{mstring}"
  end

  def modelname m
    m.name.gsub(/^#{DataModel.name}::/, "").gsub /::/, "-"
  end

  def typename t
    t.name.gsub(/^#{t.domain}::/, "").gsub /::/, "-"
  end

end