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
    pput %Q("#{@node}" [label=<<table BORDER="1" CELLBORDER="0" CELLSPACING="0"><TH><TD>#{@node}</TD></TH><HR/>)
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

  def link el1, el2
    pput %Q!"#{el1}" -> "#{el2}";\n!
  end

end

class Diagram
  attr_accessor :path, :name

  def initialize path, name
    self.path = path
    self.name = name
  end

  def dotfile
    File.join(self.path, "#{self.name}.dot")
  end

  def jpgfile
    File.join(self.path, "#{self.name}.jpg")
  end

  def describe model

    FileUtils.mkpath self.path
    File.open(self.dotfile, "w") do |file|
      graph = Graph.new(file)
      subgraph = SubGraph.new(file, modelname(model))
      for type in model.types.values
        table = TableElement.new(file, typename(model, type))
        for att in type.attributes.keys
          table.item att
        end
        table.finish
        links = Links.new(file)
        for att in type.attributes.keys
          if type.attributes[att][:links]
            links.link typename(model, type), typename( model, type.attributes[att][:links])
          end
        end
      end
      subgraph.finish
      graph.finish
    end

    unless system("dot -Tjpg #{self.dotfile} > #{self.jpgfile}")
      puts "Error: couldn't create jpeg: #{self.jpgfile}"
    end

  end

  def modelname m
    m.name.gsub(/^#{DataModel.name}::/, "").gsub /::/, "-"
  end

  def typename m, t
    t.name.gsub(/^#{m.name}::/, "").gsub /::/, "-"
  end

end